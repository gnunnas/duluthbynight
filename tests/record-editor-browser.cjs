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
 rows.campaign_status=[];let conflict=false,conflictCode='40001';
 page.on('pageerror',e=>errors.push(e.message));
 await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
  const req=route.request(),url=new URL(req.url()),table=url.pathname.split('/').pop();let body,status=200;
  if(table==='token')body={access_token:'test',refresh_token:'test',expires_in:3600,user:{id:'st'}};
  else if(table==='campaign_memberships')body=[{user_id:'st',role:'storyteller',active:true}];
  else if(table==='campaigns')body=[{owner_user_id:'st'}];
  else if(table==='edit_campaign_rows'){
   const changes=req.postDataJSON().p_changes;requests.push(changes);
   if(conflict){status=409;body={code:conflictCode};conflict=false;}
   else{body=[];for(const c of changes){if(c.insert)rows[c.table].push({...c.patch,id:c.id,campaign_id:'duluth-by-night',revision:1});else{const row=rows[c.table].find(r=>(r.id||r.power_record_id)===c.id);assert(row);Object.assign(row,c.patch,{revision:row.revision+1});}}}
  }else{const offset=Number(url.searchParams.get('offset')||0);body=(rows[table]||[]).slice(offset,offset+500);}
  await route.fulfill({status,contentType:'application/json',body:JSON.stringify(body)});
 });
 await page.goto(base+'/campaign.html#edit/person%3Aalan-sovereign');
 await page.locator('[name=email]').fill('st@example.com');await page.locator('[name=password]').fill('password');await page.getByRole('button',{name:'Sign in',exact:true}).click();
 await page.getByRole('heading',{name:'Edit Alan Sovereign',exact:true}).waitFor();
 const ambition='item:person:alan-sovereign:person.ambition';
 const form=()=>page.locator(`form[data-edit-id="${ambition}"]`);
 await form().locator('..').locator(':scope > summary').click();
 await form().locator('[name=value]').fill('Test link to Horatio Ballard');
 await form().locator('[name=newLink]').fill('Horatio Ballard · person (horatio-ballard)');
 await form().locator('[name=newLinkLabel]').fill('Horatio Ballard');
 await form().getByRole('button',{name:'Save entry'}).click();await page.getByText('Saved. Entries reloaded from the database.').waitFor();
 assert(requests.at(-1).some(c=>c.insert&&c.patch.target_record_id==='person:horatio-ballard'));
 await form().locator('..').locator(':scope > summary').click();await form().locator('[name=value]').fill('Unsaved draft');conflict=true;
 await form().getByRole('button',{name:'Save entry'}).click();await page.getByText('Another edit was saved first. Reload the latest version; your draft has not been saved.').waitFor();assert.equal(await form().locator('[name=value]').inputValue(),'Unsaved draft');
 await page.getByRole('button',{name:'Reload saved entries'}).click();await form().locator('..').locator(':scope > summary').click();
 await form().locator('[name=audience]').selectOption('players');await form().getByRole('button',{name:'Save entry'}).click();await page.locator('.reveal-dialog').waitFor();
 assert((await page.locator('.reveal-dialog').textContent()).includes('Horatio Ballard'));
 await page.getByRole('button',{name:'Reveal these entries'}).click();await page.waitForFunction(()=>!document.querySelector('.reveal-dialog')?.open);
 assert.equal(rows.records.find(r=>r.id==='person:alan-sovereign').audience,'players');assert.equal(rows.sections.find(r=>r.id==='section:person:alan-sovereign:facts').audience,'players');
 assert.equal(rows.content_items.find(r=>r.id==='item:person:alan-sovereign:person.humanity').audience,'storyteller');
 assert.equal(rows.content_items.find(r=>r.field_key==='notes.storyteller').audience,'storyteller');
 for(const width of [375,1280]){await page.setViewportSize({width,height:850});await form().locator('..').evaluate(e=>e.open=true);assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
 // Reveal all previews without writing, and keeps protected and separate records private.
 await page.getByRole('button',{name:'Reveal all',exact:true}).click();await page.locator('.reveal-dialog').waitFor();
 const beforeAll=requests.length;await page.getByRole('button',{name:'Cancel',exact:true}).click();assert.equal(requests.length,beforeAll);
 await page.getByRole('button',{name:'Reveal all',exact:true}).click();conflict=true;conflictCode='PT409';
 await page.getByRole('button',{name:'Reveal these entries'}).click();await page.getByText('Nothing in this batch was revealed. Some entries changed since this page loaded. Reload and review again before confirming.').waitFor();
 assert(await page.getByRole('button',{name:'Reveal these entries'}).isDisabled());
 await page.getByRole('button',{name:'Reload and review again'}).click();await page.getByRole('button',{name:'Reveal these entries'}).click();await page.waitForFunction(()=>!document.querySelector('.reveal-dialog')?.open);
 assert(rows.content_items.filter(r=>r.record_id==='person:alan-sovereign'&&r.field_key!=='notes.storyteller'&&!r.id.startsWith('test-')).every(r=>r.audience==='players'));
 assert.equal(rows.content_items.find(r=>r.id==='item:person:alan-sovereign:storyteller-notes').audience,'storyteller');
 assert.equal(rows.sections.find(r=>r.id==='section:person:alan-sovereign:storyteller-notes').audience,'storyteller');
 assert(rows.content_items.filter(r=>r.id.startsWith('test-')).every(r=>r.audience==='storyteller'));
 assert(rows.content_items.filter(r=>r.record_id==='person:horatio-ballard').every(r=>r.audience=== (r.field_key==='notes.player'?'players':'storyteller')));
 await page.goto(base+'/campaign.html#storyteller');await page.getByRole('heading',{name:'Storyteller tools',exact:true}).waitFor();
 await page.locator('[data-editor-search]').fill('Alan Sovereign');assert.equal(await page.locator('[data-editor-record]:visible').count(),2);
 await page.locator('[data-editor-type]').selectOption('person');assert.equal(await page.locator('[data-editor-record]:visible').count(),1);
 await page.locator('[data-editor-type]').selectOption('place');assert.equal(await page.locator('[data-editor-record]:visible').count(),0);
 await page.locator('[data-editor-search]').fill('');assert(await page.locator('[data-editor-record]:visible').count()>0);assert((await page.locator('[data-editor-record]:visible').evaluateAll(nodes=>nodes.map(n=>n.dataset.recordType))).every(type=>type==='place'));
 await page.locator('[data-editor-type]').selectOption('');assert.equal(await page.locator('[data-editor-record]:visible').count(),rows.records.length);
 for(const width of [375,1280]){await page.setViewportSize({width,height:850});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
 await page.locator('[data-editor-type]').selectOption('place');await page.locator('[data-editor-search]').fill('Watchtower');
 assert.equal(await page.locator('[data-editor-record]:visible').count(),1);
 await page.getByRole('button',{name:'Reveal all matching records'}).click();await page.locator('.reveal-dialog').waitFor();
 assert((await page.locator('.reveal-dialog').textContent()).includes('Watchtower'));
 const beforeBulk=requests.length;await page.getByRole('button',{name:'Cancel',exact:true}).click();assert.equal(requests.length,beforeBulk);
 await page.getByRole('button',{name:'Reveal all matching records'}).click();await page.getByRole('button',{name:'Reveal these entries'}).click();await page.waitForFunction(()=>!document.querySelector('.reveal-dialog')?.open);
 const location=rows.records.find(r=>r.record_type==='place'&&r.display_name==='The Watchtower');assert(location);
 assert(rows.content_items.filter(r=>r.record_id===location.id&&r.field_key!=='notes.storyteller').every(r=>r.audience==='players'));
 assert.equal(rows.content_items.find(r=>r.record_id===location.id&&r.field_key==='notes.storyteller').audience,'storyteller');
 await page.locator('[data-editor-search]').fill('');await page.locator('[data-editor-type]').selectOption('');
 await page.getByRole('button',{name:'Review homepage records'}).click();await page.locator('.reveal-dialog').waitFor();const text=await page.locator('.reveal-dialog').textContent();assert(text.includes('Record name'));await page.getByRole('button',{name:'Reveal these entries'}).click();await page.waitForFunction(()=>!document.querySelector('.reveal-dialog')?.open);
 assert(rows.records.filter(r=>['thread','session'].includes(r.record_type)).every(r=>r.audience==='players'));
 assert(!requests.at(-1).some(c=>c.table==='content_items'&&rows.content_items.find(r=>r.id===c.id)?.field_key==='notes.storyteller'));
 assert(rows.sources.every(r=>r.audience==='storyteller'));
 assert.deepEqual(errors,[]);await browser.close();console.log('PASS: field editing, linked text, stale drafts, reveal dependency review, bulk sharing and responsive editor.');
})().catch(e=>{console.error(e);process.exit(1)});
