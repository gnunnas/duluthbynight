const {chromium}=require('playwright'),assert=require('node:assert/strict');
const {exportDraft}=require('../scripts/export-supabase-draft.cjs');
const base=(process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8007').replace(/\/$/,'');
(async()=>{
 const rows=exportDraft().tables;
 for(const status of ['yes','no','unknown']){
  const id='person:test-death-'+status;
  rows.records.push({campaign_id:'duluth-by-night',id,record_type:'person',route_key:'test-death-'+status,display_name:'Test character '+status,audience:'storyteller'});
  (rows.person_status||=[]).push({id:'status:'+id,person_record_id:id,permanently_dead:status,audience:'storyteller'});
 }
 const browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']});
 try{
  const page=await browser.newPage(),errors=[];page.on('pageerror',error=>errors.push(error.message));
  // Model an old unversioned app retained in the browser cache after the login page reloads.
  await page.route(/\/app\.js$/,route=>route.fulfill({contentType:'application/javascript',body:'document.querySelector("#app").textContent="Old cached app";'}));
  await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
   const url=new URL(route.request().url()),table=url.pathname.split('/').pop();let body;
   if(url.pathname.startsWith('/auth/v1/token'))body={access_token:'fixture',refresh_token:'fixture',expires_in:3600,user:{id:'storyteller'}};
   else if(table==='campaign_memberships')body=[{user_id:'storyteller',role:'storyteller',active:true}];
   else if(table==='campaigns')body=[{owner_user_id:'storyteller'}];
   else body=(rows[table]||[]).slice(Number(url.searchParams.get('offset')||0),Number(url.searchParams.get('offset')||0)+500);
   await route.fulfill({contentType:'application/json',body:JSON.stringify(body)});
  });
  await page.goto(base+'/campaign.html#people');
  await page.locator('[name=email]').fill('fixture@example.test');await page.locator('[name=password]').fill('fixture');await page.getByRole('button',{name:'Sign in',exact:true}).click();await page.getByRole('heading',{name:'People',exact:true}).waitFor();
  const versions=await page.evaluate(()=>[document.querySelector('link[href*="styles.css"]').href,document.querySelector('script[src*="supabase-session.js"]').src,document.querySelector('script[src*="app.js"]').src].map(src=>new URL(src).searchParams.get('v')));
  assert(versions[0]);assert(versions.every(version=>version===versions[0]),'Style, login and delayed app versions must match');
  const dead=page.locator('a.card[href="#people/test-death-yes"]');assert.equal(await dead.locator('.death-mark').count(),1);assert((await dead.textContent()).includes('Test character yes'));assert.equal(await dead.getAttribute('aria-description'),'Permanently dead');
  assert(await dead.evaluate(anchor=>{const heading=anchor.querySelector('h3'),range=document.createRange();range.selectNodeContents(heading.lastChild);return heading.querySelector('.death-mark').getBoundingClientRect().right<=range.getBoundingClientRect().left+1}),'X must not cover the name');
  for(const status of ['no','unknown'])assert.equal(await page.locator('a[href="#people/test-death-'+status+'"] .death-mark').count(),0);
  await page.goto(base+'/campaign.html#search');await page.locator('#campaignSearch').fill('Test character yes');assert.equal(await page.locator('#searchResults .death-mark').count(),1);
  await page.evaluate(()=>{D.personStatus=D.personStatus.filter(status=>status.personRecordId!=='person:test-death-yes');render()});assert.equal(await page.locator('#searchResults .death-mark').count(),0,'Unavailable death status must not be disclosed');
  assert.deepEqual(errors,[]);console.log('PASS: versioned login bypasses stale app; readable death marks, search, No/Unknown and hidden-status behavior.');
 }finally{await browser.close();}
})().catch(error=>{console.error(error);process.exit(1)});
