const {chromium}=require('playwright'),assert=require('node:assert/strict'),fs=require('node:fs');
const base=(process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8028').replace(/\/$/,'');

(async()=>{
 const browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']});
 try{
  const page=await browser.newPage(),errors=[];
  page.on('pageerror',error=>errors.push(error.message));
  await page.goto(base+'/campaign.html');
  await page.waitForFunction(()=>typeof renderCampaignHTML==='function'&&DOMPurify?.version==='3.4.17');
  const result=await page.evaluate(async()=>{
   globalThis.__campaignXssExecuted=false;
   const host=document.createElement('section');
   renderCampaignHTML(host,`<script>globalThis.__campaignXssExecuted=true</script><img src="x" onerror="globalThis.__campaignXssExecuted=true"><a href="javascript:globalThis.__campaignXssExecuted=true">unsafe link</a><form data-edit-table="content_items"><input name="body" value="safe"><button type="submit">Save</button></form><svg viewBox="0 0 10 10"><path d="M0 0 10 10"></path></svg>`);
   document.body.append(host);
   await new Promise(resolve=>setTimeout(resolve,50));
   return {
    executed:globalThis.__campaignXssExecuted,
    scripts:host.querySelectorAll('script').length,
    handlers:host.querySelectorAll('[onerror]').length,
    unsafeHref:host.querySelector('a')?.getAttribute('href')||null,
    formValue:host.querySelector('form[data-edit-table="content_items"]')?.elements.body.value,
    buttonType:host.querySelector('button')?.type,
    svgPath:host.querySelector('svg path')?.getAttribute('d')
   };
  });
  assert.equal(result.executed,false);
  assert.equal(result.scripts,0);
  assert.equal(result.handlers,0);
  assert.equal(result.unsafeHref,null);
  assert.equal(result.formValue,'safe');
  assert.equal(result.buttonType,'submit');
  assert.equal(result.svgPath,'M0 0 10 10');
  const app=fs.readFileSync('app.js','utf8'),editor=fs.readFileSync('record-editor.js','utf8');
  assert(!/app\.innerHTML\s*=/.test(app),'Main campaign renderer must not assign generated HTML directly');
  assert(!/(?:results|abilityDialog)\.innerHTML\s*=/.test(app),'Search and ability renderers must use the sanitizer boundary');
  assert(!/(?:form|container|dialog)\.innerHTML\s*=/.test(editor),'Storyteller editor renderers must use the sanitizer boundary');
  assert.deepEqual(errors,[]);
  console.log('PASS: DOMPurify blocks executable markup and unsafe URLs while preserving campaign forms, data attributes, and SVG artwork.');
 }finally{await browser.close();}
})().catch(error=>{console.error(error);process.exit(1)});
