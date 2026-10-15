const {chromium}=require('playwright'),assert=require('node:assert/strict');
const {exportDraft}=require('../scripts/export-supabase-draft.cjs'),{pageBundle,searchRecords}=require('./helpers/page-bundles.cjs');
const base=process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8028';
(async()=>{
 const browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']});
 try{
  const rows=exportDraft().tables,calls=[],errors=[],page=await browser.newPage();let failPower=false,delayPerson=false;
  const system=rows.content_items.find(r=>r.record_id==='power:auspex:heightened-senses'&&r.field_key==='power.system');system.body='UNLOADED_RULES_SENTINEL '+system.body;
  const archive=rows.content_items.find(r=>r.record_id==='note:alan-sovereign');archive.body='ARCHIVE_SENTINEL '+archive.body+' historical archive'.repeat(20000);
  page.on('pageerror',e=>errors.push(e.message));
  await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
   const req=route.request(),name=new URL(req.url()).pathname.split('/').pop();let body,status=200;
   if(name==='token')body={access_token:'fixture',refresh_token:'fixture',expires_in:3600,user:{id:'storyteller'}};
   else if(name==='campaign_memberships')body=[{user_id:'storyteller',role:'storyteller',active:true}];
   else if(name==='campaigns')body=[{owner_user_id:'storyteller'}];
   else if(name==='load_campaign_page'){
    const p=req.postDataJSON();calls.push(p);
    if(failPower&&p.p_record==='power:auspex:heightened-senses'){failPower=false;status=503;body={};}
    else{if(delayPerson&&p.p_record==='person:alan-sovereign')await new Promise(r=>setTimeout(r,400));body=pageBundle(rows,p.p_scope,p.p_record);}
   }else if(name==='search_campaign_records')body=searchRecords(rows,req.postDataJSON().p_query);
   else if(name==='logout')body={};
   else throw Error('Unexpected bulk table request: '+name);
   await route.fulfill({status,contentType:'application/json',body:JSON.stringify(body)});
  });
  await page.goto(base+'/campaign.html');await page.locator('[name=email]').fill('fixture@example.test');await page.locator('[name=password]').fill('fixture');await page.getByRole('button',{name:'Sign in',exact:true}).click();await page.locator('.hero').waitFor();
  assert.deepEqual(calls.map(p=>p.p_scope),['catalog']);
  assert(!await page.evaluate(()=>JSON.stringify(CAMPAIGN).includes('ARCHIVE_SENTINEL')));assert(!await page.evaluate(()=>JSON.stringify(CAMPAIGN).includes('UNLOADED_RULES_SENTINEL')));
  async function go(hash,heading){await page.evaluate(h=>location.hash=h,hash);await page.getByRole('heading',{name:heading,exact:true}).waitFor();}
  await go('#people','People');assert.equal(calls.length,1);
  await go('#people/alan-sovereign','Alan Sovereign');assert.equal(calls.at(-1).p_record,'person:alan-sovereign');
  assert(!await page.evaluate(()=>JSON.stringify(CAMPAIGN).includes('UNLOADED_RULES_SENTINEL')));
  failPower=true;await page.getByRole('link',{name:'Heightened Senses',exact:true}).click();await page.locator('dialog [role=alert]').waitFor();await page.keyboard.press('Escape');await page.locator('dialog').waitFor({state:'hidden'});
  // Another author adds a referenced record after this account's catalog was loaded.
  rows.records.push({campaign_id:'duluth-by-night',id:'person:late-reference',record_type:'person',route_key:'late-reference',display_name:'Late reference',audience:'storyteller'});
  rows.item_references.push({id:'reference:late-target',item_id:system.id,target_record_id:'person:late-reference',label:'Late reference'});
  await page.getByRole('link',{name:'Heightened Senses',exact:true}).click();await page.locator('dialog [role=status]').waitFor({state:'hidden'});assert.equal(await page.locator('dialog [role=alert]').count(),0,'Popup should refresh stale catalog dependencies');await page.locator('dialog').getByText(/UNLOADED_RULES_SENTINEL/).waitFor();assert(await page.evaluate(()=>CAMPAIGN.records.some(r=>r.id==='person:late-reference')));await page.keyboard.press('Escape');await page.locator('dialog').waitFor({state:'hidden'});
  const cachedCount=calls.length;await page.getByRole('link',{name:'Heightened Senses',exact:true}).click();await page.locator('dialog').getByText(/UNLOADED_RULES_SENTINEL/).waitFor();await page.keyboard.press('Escape');await page.locator('dialog').waitFor({state:'hidden'});assert.equal(calls.length,cachedCount);
  await go('#people','People');await go('#people/alan-sovereign','Alan Sovereign');assert.equal(calls.length,cachedCount);
  await go('#places/rack','Canal Park · The Rack');await page.getByText('Containing district is unconfirmed.',{exact:false}).waitFor();
  await go('#search','Campaign search');await page.locator('#campaignSearch').fill('ARCHIVE_SENTINEL');await page.locator('#searchResults').getByRole('link',{name:/Alan Sovereign/}).waitFor();assert(!await page.evaluate(()=>JSON.stringify(CAMPAIGN).includes('ARCHIVE_SENTINEL')));
  await go('#notes/alan-sovereign','Alan Sovereign — imported notes');assert(await page.evaluate(()=>JSON.stringify(CAMPAIGN).includes('ARCHIVE_SENTINEL')));
  // A late detail response may populate the cache, but must not replace the chosen route.
  await page.evaluate(()=>campaignSession.reloadCampaign());delayPerson=true;
  await page.evaluate(()=>location.hash='#people/alan-sovereign');await page.getByText('Loading…',{exact:true}).waitFor();await go('#places','Places');await page.waitForTimeout(500);assert.equal(await page.getByRole('heading',{name:'Places',exact:true}).count(),1);
  assert.deepEqual(errors,[]);assert(!calls.some(p=>p.p_scope==='editor'));
  console.log('PASS: catalog-only login/listings, lazy/cached details and ability rules, failed-load retry, stale popup dependency recovery, geography warnings, server search of unloaded archives, on-demand archive and fast navigation.');
 }finally{await browser.close();}
})().catch(e=>{console.error(e);process.exit(1)});
