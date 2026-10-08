const {chromium}=require('playwright'),assert=require('node:assert/strict');
const {exportDraft}=require('../scripts/export-supabase-draft.cjs');
const base=(process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8007').replace(/\/$/,'');
(async()=>{
 const browser=await chromium.launch({executablePath:'/usr/bin/chromium',headless:true,args:['--no-sandbox']});
 const rows=exportDraft().tables;
 rows.campaign_status=[{campaign_id:'duluth-by-night',id:'hero-tagline',label:'Hero tagline',value:'The lake is black. The harbor never sleeps. Every favor leaves a mark.',sort_order:-1,audience:'players',revision:1},{campaign_id:'duluth-by-night',id:'date',label:'Current night',value:'After Sept. 11',sort_order:0,audience:'players',revision:1},{campaign_id:'duluth-by-night',id:'weather',label:'Weather',value:'',sort_order:1,audience:'players',revision:1}];
 for(const role of ['storyteller','player','player-revealed']){
  const page=await browser.newPage({viewport:{width:375,height:850}});const errors=[],requested=[];let saves=0,statusSaves=0;rows.campaign_status[2]={campaign_id:'duluth-by-night',id:'weather',label:'Weather',value:'',sort_order:1,audience:'players',revision:1};page.on('pageerror',e=>errors.push(e.message));page.on('request',r=>requested.push(r.url()));
  await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
   const url=new URL(route.request().url());let body;
   if(url.pathname.startsWith('/auth/v1/token'))body={access_token:'test-access',refresh_token:'test-refresh',expires_in:3600,user:{id:role}};
   else if(url.pathname.endsWith('/logout'))body={};
   else{
    assert.equal(route.request().headers().authorization,'Bearer test-access');
    const table=url.pathname.split('/').pop();
    if(table==='campaign_status')body=rows.campaign_status;
    else if(table==='campaign_memberships')body=[{user_id:role,role:role==='storyteller'?'storyteller':'player',active:true}];
    else if(table==='campaigns')body=[{owner_user_id:'storyteller'}];
    else if(role==='player')body=[];
    else if(role==='player-revealed')body=(rows[table]||[]).filter(row=>table==='content_items'?row.field_key!=='notes.storyteller':table==='sections'?row.template_key!=='storyteller-notes':true);
    else body=rows[table]||[];
    if(route.request().method()==='PATCH'&&table==='campaign_status'){
     assert.equal(role,'storyteller');const patch=route.request().postDataJSON();assert.equal(patch.origin,'human');assert.equal(url.searchParams.get('campaign_id'),'eq.duluth-by-night');
     const target=rows.campaign_status.find(x=>'eq.'+x.id===url.searchParams.get('id'));assert(target);assert(url.searchParams.get('revision').startsWith('eq.'));
     if(++statusSaves===2)body=[];else{Object.assign(target,patch,{revision:target.revision+1});body=[target];}
    }else if(route.request().method()==='PATCH'){
     const patch=route.request().postDataJSON();if(role==='storyteller')assert.equal(patch.origin,'human');else assert.deepEqual(Object.keys(patch),['body']);
     assert(url.searchParams.get('revision').startsWith('eq.'));body=++saves===1?[{...patch,revision:2}]:[];
    }
   }
   await route.fulfill({status:200,contentType:'application/json',body:JSON.stringify(body)});
  });
  // SQL export rows acquire a revision from PostgreSQL on insert.
  for(const row of rows.content_items)row.revision=1;
  await page.goto(base+'/campaign.html');
  assert.equal(await page.locator('#signIn').count(),1);
  assert(!requested.some(x=>/\/(data|campaign-additions|discipline-data|watchtower-data|source-notes)\.js/.test(x)));
  await page.locator('[name=email]').fill('test@example.com');await page.locator('[name=password]').fill('test-password');await page.getByRole('button',{name:'Sign in',exact:true}).click();
  await page.getByRole('button',{name:'Sign out'}).waitFor();
  await page.locator('.status').waitFor();
  assert((await page.locator('.status').textContent()).includes('After Sept. 11'));
  assert.equal(await page.getByText('Weather',{exact:true}).count(),0);
  if(role==='storyteller'){
   await page.getByRole('button',{name:'Open navigation'}).click();await page.getByRole('link',{name:'Storyteller',exact:true}).click();await page.getByRole('heading',{name:'Storyteller tools',exact:true}).waitFor();
   const weather=page.locator('form[data-status-id="weather"]');await weather.locator('[name=value]').fill('Test weather');await weather.getByRole('button',{name:'Save row'}).click();await weather.getByText('Saved. Tonight is updated.').waitFor();
   await weather.locator('[name=value]').fill('Stale weather draft');await weather.getByRole('button',{name:'Save row'}).click();await weather.getByText('This row changed or access was removed. Reload saved values and review the latest version before saving.').waitFor();assert.equal(await weather.locator('[name=value]').inputValue(),'Stale weather draft');
   await page.getByRole('button',{name:'Reload saved values'}).click();await page.getByText('Saved values reloaded.').waitFor();assert.equal(await page.locator('form[data-status-id="weather"] [name=value]').inputValue(),'Test weather');
   for(const width of [375,1280]){await page.setViewportSize({width,height:850});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
   const tagline=page.locator('form[data-status-id="hero-tagline"]');await tagline.locator('[name=value]').fill('Test session tagline');await tagline.getByRole('button',{name:'Save row'}).click();await tagline.getByText('Saved. Tonight is updated.').waitFor();
   await page.getByRole('link',{name:'View Tonight'}).click();await page.getByText('Test weather',{exact:false}).waitFor();assert.equal(await page.locator('.hero-tagline').textContent(),'Test session tagline');assert(!(await page.locator('.status').textContent()).includes('Test session tagline'));
   await page.goto(base+'/campaign.html#storyteller');await page.locator('form[data-status-id="hero-tagline"] [name=value]').fill('');await page.locator('form[data-status-id="hero-tagline"]').getByRole('button',{name:'Save row'}).click();await page.locator('form[data-status-id="hero-tagline"]').getByText('Saved. Tonight is updated.').waitFor();await page.getByRole('link',{name:'View Tonight'}).click();assert.equal(await page.locator('.hero-tagline').count(),0);

  }else{
   await page.getByRole('button',{name:'Open navigation'}).click();assert.equal(await page.getByRole('link',{name:'Storyteller',exact:true}).count(),0);await page.goto(base+'/campaign.html#storyteller');await page.getByRole('heading',{name:'Storyteller access required'}).waitFor();assert.equal(await page.locator('form[data-status-id]').count(),0);await page.goto(base+'/campaign.html#edit/person%3Aalan-sovereign');await page.getByRole('heading',{name:'Storyteller access required'}).waitFor();assert.equal(await page.locator('form[data-edit-table]').count(),0);await page.getByRole('link',{name:'Return to Tonight',exact:true}).click();
  }
  if(role==='player')await page.getByText('No campaign records have been revealed to this account yet.').waitFor();
  else{
   await page.goto(base+'/campaign.html#people/alan-sovereign');
   await page.getByRole('heading',{name:'Alan Sovereign',exact:true}).waitFor();
   for(const width of [375,1280]){
    await page.setViewportSize({width,height:850});
    assert(await page.locator('.npc-detail .facts').evaluate(facts=>{
     const full=facts.getBoundingClientRect().width-2,rows=new Map();
     for(const field of facts.children){const box=field.getBoundingClientRect(),key=Math.round(box.top);if(!rows.has(key))rows.set(key,[]);rows.get(key).push(box);}
     return [...rows.values()].every(row=>row.length===2||Math.abs(row[0].width-full)<2);
    }),'NPC summary leaves an empty grid cell at '+width);
   }

   await page.getByRole('link',{name:'Heightened Senses',exact:true}).click();assert(await page.locator('dialog').isVisible());await page.keyboard.press('Escape');
   const form=page.locator('form[data-note-id]').first();await form.locator('..').locator('summary').click();await form.locator('textarea').fill('Shared note test');await form.getByRole('button').click();await page.getByText('Shared note test',{exact:true}).first().waitFor();
   const retryForm=page.locator('form[data-note-id]').first();await retryForm.locator('..').locator('summary').click();await retryForm.locator('textarea').fill('Stale edit');await retryForm.getByRole('button').click();await page.getByText('This note changed or access was removed. Reload and review the latest version before saving.').waitFor();
   for(const width of [375,1280]){await page.setViewportSize({width,height:850});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
  }
  await page.getByRole('button',{name:'Sign out'}).click();await page.locator('#signIn').waitFor();assert.equal(await page.getByText('Alan Sovereign',{exact:true}).count(),0);
  assert.deepEqual(errors,[]);await page.close();
 }
 const failed=await browser.newPage();await failed.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',route=>route.fulfill({status:400,contentType:'application/json',body:'{}'}));
 await failed.goto(base+'/campaign.html');await failed.locator('[name=email]').fill('test@example.com');await failed.locator('[name=password]').fill('wrong-password');await failed.getByRole('button',{name:'Sign in',exact:true}).click();await failed.getByText('Sign-in failed. Check your email and password.').waitFor();assert.equal(await failed.locator('main .detail').count(),0);await failed.close();
 await browser.close();console.log('PASS: password sign-in, RLS-row projection, empty player view, popup, note save, responsive layout, sign-out and no static-data requests.');
})().catch(error=>{console.error(error);process.exit(1)});
