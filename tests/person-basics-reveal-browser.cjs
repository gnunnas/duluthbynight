const {pageBundle,searchRecords}=require('./helpers/page-bundles.cjs');
const {chromium}=require('playwright'),assert=require('node:assert/strict');
const {exportDraft}=require('../scripts/export-supabase-draft.cjs');
const base=process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8010';
(async()=>{
 const browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']});
 const page=await browser.newPage({viewport:{width:375,height:850}}),errors=[],requests=[];
 const rows=exportDraft().tables;for(const list of Object.values(rows))for(const row of list)row.revision=1;
 rows.content_items.push(
  {campaign_id:'duluth-by-night',id:'test-protected-child',record_id:'person:alan-sovereign',section_id:'section:person:alan-sovereign:storyteller-notes',parent_item_id:'item:person:alan-sovereign:storyteller-notes',item_kind:'note',body:'Protected nested test',audience:'storyteller',revision:1},
  {campaign_id:'duluth-by-night',id:'test-archived-entry',record_id:'person:alan-sovereign',section_id:'section:person:alan-sovereign:facts',item_kind:'note',body:'Archived test',archived_at:'2026-01-01T00:00:00Z',audience:'storyteller',revision:1}
 );
 rows.campaign_status=[];let conflict=false,conflictCode='40001',role='storyteller';
 page.on('pageerror',e=>errors.push(e.message));
 await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
  const req=route.request(),url=new URL(req.url()),table=url.pathname.split('/').pop();let body,status=200;
  if(table==='token')body={access_token:'test',refresh_token:'test',expires_in:3600,user:{id:'st'}};
  else if(table==='campaign_memberships')body=[{user_id:'st',role,active:true}];
  else if(table==='campaigns')body=[{owner_user_id:role==='storyteller'?'st':'owner'}];
   else if(table==='load_campaign_page'){const p=route.request().postDataJSON();body=pageBundle(rows,p.p_scope,p.p_record);}
   else if(table==='search_campaign_records')body=searchRecords(rows,route.request().postDataJSON().p_query);
  else if(table==='edit_campaign_rows'){
   const changes=req.postDataJSON().p_changes;requests.push(changes);
   if(conflict){status=409;body={code:conflictCode};conflict=false;}
   else{body=[];for(const c of changes){if(c.insert)rows[c.table].push({...c.patch,id:c.id,campaign_id:'duluth-by-night',revision:1});else{const row=rows[c.table].find(r=>(r.id||r.power_record_id)===c.id);assert(row);Object.assign(row,c.patch,{revision:row.revision+1});}}}
  }else{const offset=Number(url.searchParams.get('offset')||0);body=(rows[table]||[]).slice(offset,offset+500);}
  await route.fulfill({status,contentType:'application/json',body:JSON.stringify(body)});
 });
 // This action is on the person detail, not only inside the editor.
 await page.goto(base+'/campaign.html#people/alan-sovereign');
 async function signIn(){await page.locator('[name=email]').fill('test@example.com');await page.locator('[name=password]').fill('password');await page.getByRole('button',{name:'Sign in',exact:true}).click();await page.getByRole('heading',{name:'Alan Sovereign',exact:true}).waitFor();}
 await signIn();
 const action=()=>page.getByRole('button',{name:'Reveal character basics',exact:true});
 assert.equal(await action().count(),1);
 for(const width of [375,1280]){await page.setViewportSize({width,height:850});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
 // Rows absent from the scoped page must be picked up after full dependency loading.
 const portrait=rows.attachments.find(r=>r.record_id==='person:alan-sovereign');
 rows.attachments.push({...portrait,id:'test-late-art',audience:'storyteller',revision:1});
 rows.attachments.push({...portrait,id:'test-protected-art',item_id:'test-protected-child',audience:'storyteller',revision:1});
 rows.attachments.push({...portrait,id:'test-archived-art',archived_at:'2026-01-01T00:00:00Z',audience:'storyteller',revision:1});
 rows.relationships.push({campaign_id:'duluth-by-night',id:'test-late-member',from_record_id:'person:alan-sovereign',to_record_id:'organization:night-forum',relationship_type:'member_of',knowledge_state:'recorded',audience:'storyteller',revision:1});
 rows.relationships.push({campaign_id:'duluth-by-night',id:'test-associate',from_record_id:'person:alan-sovereign',to_record_id:'organization:watchtower-security',relationship_type:'associate_of',knowledge_state:'recorded',audience:'storyteller',revision:1});
 rows.relationships.push({...rows.relationships.at(-1),id:'test-archived-member',valid_until:{start:'2020-01-01'},archived_at:'2026-01-01T00:00:00Z'});
 await action().click();await page.waitForFunction(()=>document.querySelector('.reveal-dialog')?.open||document.querySelector('#recordEditorMessage')?.textContent);assert.equal(await page.locator('#recordEditorMessage').allTextContents().then(x=>x.join('')),'');await page.locator('.reveal-dialog').waitFor();
 const preview=await page.locator('.reveal-dialog').textContent();
 assert(preview.includes('Ventrue')&&preview.includes('Camarilla')&&preview.includes('For Real Dead?')&&preview.includes('Artwork')&&preview.includes('Nature / type'));
 const before=requests.length;await page.getByRole('button',{name:'Cancel',exact:true}).click();assert.equal(requests.length,before,'Cancel must not write');
 await action().click();await page.locator('.reveal-dialog').waitFor();conflict=true;conflictCode='PT409';
 await page.getByRole('button',{name:'Reveal these entries',exact:true}).click();await page.getByText('Nothing in this batch was revealed. Some entries changed since this page loaded. Reload and review again before confirming.').waitFor();
 assert.equal(rows.attachments.find(r=>r.id==='test-late-art').audience,'storyteller');
 await page.getByRole('button',{name:'Reload and review again'}).click();await page.getByRole('button',{name:'Reveal these entries',exact:true}).click();await page.waitForFunction(()=>!document.querySelector('.reveal-dialog')?.open);
 const batch=requests.at(-1),ids=new Set(batch.map(c=>c.id));
 for(const id of ['person:alan-sovereign','relationship:alan:clan','relationship:alan:camarilla','test-late-member','test-associate','status:person:alan-sovereign','attachment:alan:portrait','test-late-art','item:person:alan-sovereign:person.nature','item:person:alan-sovereign:seneschal'])assert(ids.has(id),'Expected target '+id);
 for(const c of batch){
  assert.deepEqual(c.patch,{audience:'players'});
  const r=rows[c.table].find(r=>(r.id||r.power_record_id)===c.id);
  if(c.table==='content_items')assert(['person.nature','relationship.role'].includes(r.field_key),'Unrelated field revealed: '+r.id);
  if(c.table==='relationships')assert(['member_of','associate_of','affiliated_with','clan_member_of'].includes(r.relationship_type));
 }
 for(const id of ['test-protected-child','test-archived-entry','test-protected-art','test-archived-art','test-archived-member'])assert(!ids.has(id),'Excluded target '+id);
 assert.equal(rows.content_items.find(r=>r.id==='item:person:alan-sovereign:person.humanity').audience,'storyteller');
 assert(rows.content_items.filter(r=>r.field_key==='notes.storyteller').every(r=>r.audience==='storyteller'));
 assert(rows.sources.every(r=>r.audience==='storyteller'));
 assert(rows.content_items.filter(r=>r.record_id==='person:horatio-ballard').every(r=>r.audience===(r.field_key==='notes.player'?'players':'storyteller')));
 // A repeat has no remaining edits and non-person/player pages have no control.
 await action().click();await page.getByText('These entries are already revealed.',{exact:true}).waitFor();
 await page.goto(base+'/campaign.html#organizations/camarilla');await page.getByRole('heading',{name:'Camarilla',exact:true}).waitFor();assert.equal(await action().count(),0);
 role='player';await page.goto(base+'/campaign.html#people/alan-sovereign');await page.reload();await signIn();assert.equal(await action().count(),0);assert.equal(await page.getByText('Edit record & reveals',{exact:true}).count(),0);
 assert.deepEqual(errors,[]);await browser.close();console.log('PASS: person basics reveal scope, dependency load, cancel, conflict/retry, privacy, responsive layout and player exclusion.');
})().catch(e=>{console.error(e);process.exit(1)});
