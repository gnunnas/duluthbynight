const {chromium}=require('playwright'),assert=require('node:assert/strict');
const {exportDraft}=require('../scripts/export-supabase-draft.cjs');
(async()=>{
 const browser=await chromium.launch({executablePath:'/usr/bin/chromium',headless:true,args:['--no-sandbox']});
 const rows=exportDraft().tables;
 for(const role of ['storyteller','player','player-revealed']){
  const page=await browser.newPage({viewport:{width:375,height:850}});const errors=[],requested=[];let saves=0;page.on('pageerror',e=>errors.push(e.message));page.on('request',r=>requested.push(r.url()));
  await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
   const url=new URL(route.request().url());let body;
   if(url.pathname.startsWith('/auth/v1/token'))body={access_token:'test-access',refresh_token:'test-refresh',expires_in:3600,user:{id:role}};
   else if(url.pathname.endsWith('/logout'))body={};
   else{
    assert.equal(route.request().headers().authorization,'Bearer test-access');
    const table=url.pathname.split('/').pop();
    if(table==='campaign_memberships')body=[{user_id:role,role:role==='storyteller'?'storyteller':'player',active:true}];
    else if(table==='campaigns')body=[{owner_user_id:'storyteller'}];
    else if(role==='player')body=[];
    else if(role==='player-revealed')body=(rows[table]||[]).filter(row=>table==='content_items'?row.field_key!=='notes.storyteller':table==='sections'?row.template_key!=='storyteller-notes':true);
    else body=rows[table]||[];
    if(route.request().method()==='PATCH'){
     const patch=route.request().postDataJSON();if(role==='storyteller')assert.equal(patch.origin,'human');else assert.deepEqual(Object.keys(patch),['body']);
     assert(url.searchParams.get('revision').startsWith('eq.'));body=++saves===1?[{...patch,revision:2}]:[];
    }
   }
   await route.fulfill({status:200,contentType:'application/json',body:JSON.stringify(body)});
  });
  // SQL export rows acquire a revision from PostgreSQL on insert.
  for(const row of rows.content_items)row.revision=1;
  await page.goto('http://127.0.0.1:8007');
  assert.equal(await page.locator('#signIn').count(),1);
  assert(!requested.some(x=>/\/(data|campaign-additions|discipline-data|watchtower-data|source-notes)\.js/.test(x)));
  await page.locator('[name=email]').fill('test@example.com');await page.locator('[name=password]').fill('test-password');await page.getByRole('button',{name:'Sign in',exact:true}).click();
  await page.getByRole('button',{name:'Sign out'}).waitFor();
  if(role==='player')assert(await page.getByText('No campaign records have been revealed to this account yet.').count());
  else{
   await page.goto('http://127.0.0.1:8007/#people/alan-sovereign');
   await page.getByRole('heading',{name:'Alan Sovereign',exact:true}).waitFor();
   await page.getByRole('link',{name:'Heightened Senses',exact:true}).click();assert(await page.locator('dialog').isVisible());await page.keyboard.press('Escape');
   const form=page.locator('form[data-note-id]').first();await form.locator('..').locator('summary').click();await form.locator('textarea').fill('Shared note test');await form.getByRole('button').click();await page.getByText('Shared note test',{exact:true}).first().waitFor();
   const retryForm=page.locator('form[data-note-id]').first();await retryForm.locator('..').locator('summary').click();await retryForm.locator('textarea').fill('Stale edit');await retryForm.getByRole('button').click();await page.getByText('This note changed or access was removed. Reload and review the latest version before saving.').waitFor();
   for(const width of [375,1280]){await page.setViewportSize({width,height:850});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
  }
  await page.getByRole('button',{name:'Sign out'}).click();await page.locator('#signIn').waitFor();assert.equal(await page.getByText('Alan Sovereign',{exact:true}).count(),0);
  assert.deepEqual(errors,[]);await page.close();
 }
 const failed=await browser.newPage();await failed.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',route=>route.fulfill({status:400,contentType:'application/json',body:'{}'}));
 await failed.goto('http://127.0.0.1:8007');await failed.locator('[name=email]').fill('test@example.com');await failed.locator('[name=password]').fill('wrong-password');await failed.getByRole('button',{name:'Sign in',exact:true}).click();await failed.getByText('Sign-in failed. Check your email and password.').waitFor();assert.equal(await failed.locator('main .detail').count(),0);await failed.close();
 await browser.close();console.log('PASS: password sign-in, RLS-row projection, empty player view, popup, note save, responsive layout, sign-out and no static-data requests.');
})().catch(error=>{console.error(error);process.exit(1)});
