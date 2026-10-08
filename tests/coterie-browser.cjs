const {chromium}=require('playwright'),assert=require('node:assert/strict');
const {exportDraft}=require('../scripts/export-supabase-draft.cjs');
const base=process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8018';
(async()=>{
 const browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']});
 for(const role of ['storyteller','player']){
  const rows=exportDraft().tables,id='organization:player-coterie';
  rows.records.push({campaign_id:'duluth-by-night',id,record_type:'organization',route_key:'player-coterie',display_name:'Coterie',audience:'players',revision:1});
  for(const key of ['facts','boons','resources','player-notes'])rows.sections.push({campaign_id:'duluth-by-night',id:'section:'+id+':'+key,record_id:id,template_key:key,heading:key,display_style:'list',sort_order:1,audience:'players',revision:1});
  const item=(key,section,extra={})=>rows.content_items.push({campaign_id:'duluth-by-night',id:'test:'+key,record_id:id,section_id:'section:'+id+':'+section,field_key:key,item_kind:'note',knowledge_state:'recorded',audience:'players',revision:1,...extra});
  item('organization.browseCategory','facts',{value:'group'});item('organization.kind','facts',{value:'Coterie'});
  item('coterie.haven','facts',{reference_record_id:'place:watchtower'});item('notes.player','player-notes',{body:'Initial shared notes'});
  item('coterie.boon','boons',{title:'Favor owed',value:{direction:'owed_by_coterie',status:'outstanding'}});
  item('coterie.boon2','boons',{field_key:'coterie.boon',title:'Favor given',value:{direction:'owed_to_coterie',status:'outstanding'}});
  item('coterie.resource','resources',{title:'Shared funds',value:{quantity:'2'}});item('coterie.resource2','resources',{field_key:'coterie.resource',title:'Transport'});
  rows.relationships.push({campaign_id:'duluth-by-night',id:'test:member',relationship_type:'member_of',from_record_id:'person:alan-sovereign',to_record_id:id,audience:'players',revision:1});
  for(const table of Object.values(rows))for(const r of table)r.revision??=1;
  for(const r of rows.records)r.audience='players';
  const page=await browser.newPage({viewport:{width:1280,height:900}}),errors=[];page.on('pageerror',e=>errors.push(e.message));
  await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
   const req=route.request(),url=new URL(req.url()),table=url.pathname.split('/').pop();let body;
   if(url.pathname.startsWith('/auth/v1/token'))body={access_token:'test',refresh_token:'refresh',expires_in:3600,user:{id:role}};
   else if(table==='campaign_memberships')body=[{user_id:role,role,active:true}];
   else if(table==='campaigns')body=[{owner_user_id:'storyteller'}];
   else if(table==='save_coterie_entry'){
    assert.equal(role,'storyteller');const p=req.postDataJSON(),payload=p.p_payload;assert.equal(p.p_kind,'resource');
    item('coterie.resource3','resources',{field_key:'coterie.resource',title:payload.title,body:payload.body,value:{quantity:payload.quantity}});body={id:'test:coterie.resource3'};
   }else if(req.method()==='PATCH'){
    const target=rows.content_items.find(r=>'eq.'+r.id===url.searchParams.get('id'));assert(target);Object.assign(target,req.postDataJSON());target.revision++;body=[target];
   }else body=(rows[table]||[]).filter(r=>role==='storyteller'||(r.field_key!=='notes.storyteller'&&r.template_key!=='storyteller-notes'));
   await route.fulfill({status:200,contentType:'application/json',body:JSON.stringify(body)});
  });
  await page.goto(base+'/campaign.html#coterie');await page.locator('[name=email]').fill('test@example.com');await page.locator('[name=password]').fill('password');await page.getByRole('button',{name:'Sign in',exact:true}).click();
  await page.getByRole('heading',{name:'Coterie',exact:true}).waitFor();assert.equal(await page.locator('nav a[href="#threads"]').count(),0);
  assert.equal(await page.getByRole('link',{name:'Alan Sovereign',exact:true}).count(),1);assert.equal(await page.getByRole('link',{name:'The Watchtower',exact:true}).count(),1);
  await page.getByRole('heading',{name:'Favor owed'}).waitFor();await page.getByRole('heading',{name:'Favor given'}).waitFor();
  assert.equal(await page.getByRole('heading',{name:'Shared funds'}).count(),1);assert.equal(await page.getByRole('heading',{name:'Transport',exact:true}).count(),1);
  if(role==='storyteller'){
   const form=page.locator('form[data-coterie-kind="resource"][data-entry-id=""]');await form.locator('..').locator('summary').click();await form.locator('[name=title]').fill('Third resource');await form.locator('[name=quantity]').fill('3');await form.getByRole('button').click();await page.getByRole('heading',{name:'Third resource'}).waitFor();
  }else assert.equal(await page.locator('form[data-coterie-kind]').count(),0);
  const note=page.locator('form[data-note-id]');assert(await note.locator('textarea').isVisible());const text='Long shared notes. '.repeat(1200);await note.locator('textarea').fill(text);await note.getByRole('button').click();await page.waitForFunction(t=>document.querySelector('form[data-note-id] textarea').value===t&&document.querySelector('form[data-note-id] button').disabled===false,text);assert.equal(rows.content_items.find(x=>x.field_key==='notes.player'&&x.record_id===id).body,text);
  for(const width of [375,1280]){await page.setViewportSize({width,height:900});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),'Coterie overflow');}
  await page.goto(base+'/campaign.html#chronicle');await page.getByRole('heading',{name:'Active threads',exact:true}).waitFor();
  await page.goto(base+'/campaign.html#threads');await page.getByRole('heading',{name:'Active threads',exact:true}).waitFor();
  assert.deepEqual(errors,[]);await page.close();
 }
 await browser.close();console.log('PASS: Coterie roster/haven, both boon directions, multiple resources, Storyteller creation, large shared player notes, Chronicle threads and responsive layout.');
})().catch(e=>{console.error(e);process.exit(1)});
