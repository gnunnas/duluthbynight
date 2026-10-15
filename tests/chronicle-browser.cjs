const {chromium}=require('playwright'),assert=require('node:assert/strict'),{fixture}=require('./helpers/chronicle-fixture.cjs'),{pageBundle}=require('./helpers/page-bundles.cjs');
const base=process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8028';
(async()=>{const browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']});try{
 const rows=fixture(),calls=[],errors=[],page=await browser.newPage();page.on('pageerror',e=>errors.push(e.message));
 await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
  const req=route.request(),name=new URL(req.url()).pathname.split('/').pop();let body;
  if(name==='token')body={access_token:'fixture',refresh_token:'fixture',expires_in:3600,user:{id:'storyteller'}};
  else if(name==='campaign_memberships')body=[{user_id:'storyteller',role:'storyteller',active:true}];else if(name==='campaigns')body=[{owner_user_id:'storyteller'}];
  else if(name==='load_campaign_page'){const p=req.postDataJSON();calls.push(p);body=pageBundle(rows,p.p_scope,p.p_record);}
  else throw Error('Unexpected request '+name);
  await route.fulfill({contentType:'application/json',body:JSON.stringify(body)});
 });
 await page.goto(base+'/campaign.html');await page.locator('[name=email]').fill('fixture@example.test');await page.locator('[name=password]').fill('fixture');await page.getByRole('button',{name:'Sign in',exact:true}).click();await page.locator('.hero').waitFor();
 assert.equal(await page.locator('a.card[href="#threads/kyra-hunt"]').count(),0);assert.equal(await page.locator('a.card[href="#chronicle/history-fixture"]').count(),1);
 await page.evaluate(()=>location.hash='#chronicle');await page.getByRole('heading',{name:'Chronicle',exact:true}).waitFor();
 assert.equal(await page.locator('a[href="#notes"]').count(),0);assert.equal(calls.length,1);
 await page.getByRole('link',{name:'Completed threads (1)',exact:true}).click();await page.getByRole('heading',{name:'Completed threads',exact:true}).waitFor();assert.equal(calls.length,1);assert.equal(await page.locator('a.card[href="#threads/dark-mother"]').count(),0);
 await page.getByRole('link',{name:/The Hunt for Kyra/}).click();await page.getByRole('heading',{name:'The Hunt for Kyra',exact:true}).waitFor();await page.getByText('Completed',{exact:true}).waitFor();assert.equal(calls.at(-1).p_record,'thread:kyra-hunt');
 await page.evaluate(()=>location.hash='#chronicle');await page.getByRole('link',{name:'Past session recaps (1)',exact:true}).click();await page.getByRole('heading',{name:'Past session recaps',exact:true}).waitFor();assert.equal(await page.locator('a.card[href="#chronicle/history-fixture"]').count(),0);await page.getByRole('link',{name:/Chains in the Dark/}).waitFor();
 await page.evaluate(()=>location.hash='#chronicle/history-fixture');await page.getByRole('heading',{name:'New session fixture',exact:true}).waitFor();await page.getByText('April 10, 2027',{exact:true}).waitFor();await page.getByText('June 1998',{exact:true}).waitFor();
 for(const width of [375,1280]){await page.setViewportSize({width,height:850});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
 assert.deepEqual(errors,[]);console.log('PASS: active/completed threads, readable completion detail, past sessions, distinct clocks, lazy history navigation and responsive layout.');
}finally{await browser.close();}})().catch(e=>{console.error(e);process.exit(1)});
