const {chromium}=require('playwright'),assert=require('node:assert/strict');
const base=(process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8030').replace(/\/$/,'');
(async()=>{
 const browser=await chromium.launch({executablePath:'/usr/bin/chromium',headless:true,args:['--no-sandbox']});
 const page=await browser.newPage({viewport:{width:375,height:850}}),errors=[],requests=[];let signupBody,requestCount=0;
 page.on('pageerror',error=>errors.push(error.message));page.on('request',request=>requests.push(request.url()));
 await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
  const request=route.request(),url=new URL(request.url());let body={};
  if(url.pathname.endsWith('/signup')){signupBody=request.postDataJSON();assert(url.searchParams.get('redirect_to').endsWith('/campaign.html?confirmed=1'));body={user:{id:'new-player'}};}
  else if(url.pathname.startsWith('/auth/v1/token'))body={access_token:'player-access',refresh_token:'player-refresh',expires_in:3600,user:{id:'new-player'}};
  else if(url.pathname.endsWith('/logout'))body={};
  else{
   assert.equal(request.headers().authorization,'Bearer player-access');const name=url.pathname.split('/').pop();
   if(name==='campaign_memberships'||name==='campaigns')body=[];
   else if(name==='campaign_access_request_status')body='none';
   else if(name==='request_campaign_access'){requestCount++;body='pending';}
   else throw Error('Unexpected API request: '+url.pathname);
  }
  await route.fulfill({status:200,contentType:'application/json',body:JSON.stringify(body)});
 });
 await page.goto(base+'/campaign.html');
 await page.getByRole('button',{name:'Create account',exact:true}).click();
 await page.locator('#signUp [name=signupEmail]').fill('new.player@example.test');await page.locator('#signUp [name=signupPassword]').fill('long-password');await page.locator('#signUp [name=confirmPassword]').fill('long-password');await page.locator('#signUp').getByRole('button',{name:'Create account'}).click();
 await page.getByText('Account created. Check your email and click the confirmation link, then sign in here.').waitFor();
 assert.deepEqual(signupBody,{email:'new.player@example.test',password:'long-password'});
 await page.getByRole('button',{name:'Existing account',exact:true}).click();await page.locator('#signIn [name=email]').fill('new.player@example.test');await page.locator('#signIn [name=password]').fill('long-password');await page.locator('#signIn').getByRole('button',{name:'Sign in'}).click();
 await page.getByRole('heading',{name:'Campaign access'}).waitFor();await page.getByText('This account does not have access to Duluth by Night yet.').waitFor();
 assert.equal(await page.locator('header #account').count(),0);assert.equal(await page.locator('footer #sessionActions').getByRole('button',{name:'Sign out'}).count(),1);
 assert.equal(await page.locator('#nav').isVisible(),false);assert(!requests.some(url=>/\/app\.js(?:\?|$)/.test(url)),'Unapproved account must not load the campaign app');
 await page.getByRole('button',{name:'Request player access'}).click();await page.getByText('Request sent. Your Storyteller can now approve it.').waitFor();assert.equal(requestCount,1);
 for(const width of [375,1280]){await page.setViewportSize({width,height:850});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
 assert.deepEqual(errors,[]);await browser.close();console.log('PASS: account creation, confirmation guidance, locked unapproved account, and player access request.');
})().catch(error=>{console.error(error);process.exit(1)});
