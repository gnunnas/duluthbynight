const {chromium}=require('playwright'),assert=require('node:assert/strict');
const {exportDraft}=require('../scripts/export-supabase-draft.cjs'),{pageBundle}=require('./helpers/page-bundles.cjs');
(async()=>{const browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']});try{
 const rows=exportDraft().tables,page=await browser.newPage(),errors=[],calls=[];let failDetail=true,releaseReview,reviewStarted;
 for(const list of Object.values(rows))for(const row of list)row.revision=1;
 const owner='person:kevin-jackson',section='test:large-editor';
 rows.sections.push({id:section,record_id:owner,heading:'Large record',template_key:'facts',audience:'storyteller',revision:1});
 for(let i=0;i<112;i++)rows.content_items.push({id:'test:large-field:'+i,record_id:owner,section_id:section,item_kind:'note',title:'Field '+i,body:'Editable text '+i,audience:'storyteller',revision:1});
 rows.content_items_sources=[{owner_id:'test:large-field:0',source_id:rows.sources[0].id,locator:'test provenance'}];
 page.on('pageerror',e=>errors.push(e.message));
 await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
  const req=route.request(),url=new URL(req.url()),name=url.pathname.split('/').pop();let body,status=200;
  calls.push({name,method:req.method(),params:Object.fromEntries(url.searchParams)});
  if(name==='token')body={access_token:'fixture',refresh_token:'fixture',expires_in:3600,user:{id:'st'}};
  else if(name==='campaign_memberships')body=[{user_id:'st',role:'storyteller',active:true}];
  else if(name==='campaigns')body=[{owner_user_id:'st'}];
  else if(name==='load_campaign_page'){
   const p=req.postDataJSON();assert.notEqual(p.p_scope,'editor');assert(['catalog','detail'].includes(p.p_scope));
   if(p.p_scope==='detail'&&failDetail){failDetail=false;status=503;body={};}else body=pageBundle(rows,p.p_scope,p.p_record);
  }else if(req.method()==='GET'){
   if(name==='content_items_sources'&&releaseReview){reviewStarted();await releaseReview;}
   const offset=Number(url.searchParams.get('offset')||0);body=(rows[name]||[]).filter(row=>!url.searchParams.has('note_record_id')||'eq.'+row.note_record_id===url.searchParams.get('note_record_id')).slice(offset,offset+500);
  }else throw Error('Unexpected write '+name);
  await route.fulfill({status,contentType:'application/json',body:JSON.stringify(body)});
 });
 await page.goto((process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8028')+'/campaign.html#edit/'+encodeURIComponent(owner));
 await page.locator('[name=email]').fill('st@example.test');await page.locator('[name=password]').fill('fixture');await page.getByRole('button',{name:'Sign in',exact:true}).click();
 await page.getByRole('heading',{name:'Could not load this page',exact:true}).waitFor();await page.getByRole('button',{name:'Try again',exact:true}).click();
 await page.getByRole('heading',{name:'Edit Kevin Jackson',exact:true}).waitFor();
 assert.deepEqual(calls.filter(x=>x.method==='GET').map(x=>x.name),['campaign_memberships','campaigns'],'Opening a record must not fetch campaign tables');
 assert.equal(await page.locator('[data-edit-table] input,[data-edit-table] select,[data-edit-table] textarea').count(),0,'Closed rows must not build controls');
 const form=()=>page.locator('form[data-edit-id="test:large-field:0"]');
 await form().locator('..').locator(':scope > summary').click();await form().locator('[name=body]').fill('Keep this draft');
 assert.equal(await page.locator('form[data-lazy-fields]').count(),await page.locator('[data-edit-table]').count()-1);
 assert.equal(await form().locator('[name=section_id]').count(),0,'Advanced selectors are lazy');
 await form().getByText('Advanced field structure',{exact:true}).click();await form().locator('[name=section_id]').waitFor();assert.equal(await form().locator('[name=section_id]').inputValue(),section);
 await form().locator('..').locator(':scope > summary').click();await form().locator('..').locator(':scope > summary').click();assert.equal(await form().locator('[name=body]').inputValue(),'Keep this draft');
 // Review must wait for the last attribution table and must not reopen on a later visit to the same route.
 let release;releaseReview=new Promise(r=>release=r);const started=new Promise(r=>reviewStarted=r);
 await page.getByRole('button',{name:'Reveal all',exact:true}).click();await started;
 assert.equal(await page.locator('.reveal-dialog[open]').count(),0);assert.equal(await form().locator('[name=body]').inputValue(),'Keep this draft');
 await page.evaluate(()=>location.hash='#people');await page.getByRole('heading',{name:'People',exact:true}).waitFor();
 await page.evaluate(id=>location.hash='#edit/'+encodeURIComponent(id),owner);
 release();await page.getByRole('heading',{name:'Edit Kevin Jackson',exact:true}).waitFor();await page.waitForTimeout(100);
 assert.equal(await page.locator('.reveal-dialog[open]').count(),0,'Navigation must cancel stale reveal previews');releaseReview=null;
 await page.getByRole('button',{name:'Reveal all',exact:true}).click();await page.getByRole('heading',{name:'Reveal to all campaign players?',exact:true}).waitFor();
 assert(await page.locator('.reveal-dialog li').filter({hasText:'Fields & notes: Field 111'}).count());await page.getByRole('button',{name:'Cancel',exact:true}).click();
 // A fresh full review must not replace an old form revision with newer saved content.
 const oldForm=await form().elementHandle();await page.getByRole('button',{name:'Reload saved entries',exact:true}).click();await page.waitForFunction(node=>!node.isConnected,oldForm);
 await form().locator('..').locator(':scope > summary').click();await form().locator('[name=body]').fill('Stale draft retained');await form().locator('[name=audience]').selectOption('players');
 rows.content_items.find(x=>x.id==='test:large-field:0').revision=2;
 await form().getByRole('button',{name:'Save entry',exact:true}).click();await form().getByText(/Another edit was saved first/).waitFor();
 assert.equal(await form().locator('[name=body]').inputValue(),'Stale draft retained');assert.equal(await page.locator('.reveal-dialog[open]').count(),0);
 // Source archive definitions remain editable, scoped to the selected archive.
 const currentForm=await form().elementHandle();await page.getByRole('button',{name:'Reload saved entries',exact:true}).click();await page.waitForFunction(node=>!node.isConnected,currentForm);
 await page.evaluate(()=>location.hash='#edit/'+encodeURIComponent('note:alan-sovereign'));await page.getByRole('heading',{name:'Edit Alan Sovereign — imported notes',exact:true}).waitFor();
 const sourceCalls=calls.filter(x=>x.name==='sources'&&x.params.note_record_id);assert.equal(sourceCalls.at(-1).params.note_record_id,'eq.note:alan-sovereign');
 assert(await page.locator('form[data-edit-table="sources"]').count());
 for(const width of [375,1280]){await page.setViewportSize({width,height:950});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
 assert.deepEqual(errors,[]);console.log('PASS: scoped edit retry without campaign downloads; lazy controls and draft retention; complete review and navigation cancellation; stale shared drafts; scoped archive definitions; responsive layout.');
}finally{await browser.close();}})().catch(e=>{console.error(e);process.exit(1)});
