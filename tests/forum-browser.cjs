const {chromium}=require('playwright'),assert=require('node:assert/strict');
const base=(process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8007').replace(/\/$/,'');
(async()=>{
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH||'/usr/bin/chromium',args:['--no-sandbox']});
 const page=await browser.newPage({viewport:{width:1080,height:900}}),errors=[],requests=[];
 page.on('pageerror',e=>errors.push(e.message));page.on('request',r=>requests.push(r.url()));
 await page.goto(base+'/');
 assert.equal(await page.title(),'Forum Index :: Verumdetenebris');
 const data=await page.evaluate(()=>VERUM_FORUM);
 const memberNames=Object.keys(data.members);
 for(const thread of data.threads)for(const post of thread.posts)assert(memberNames.includes(post[0]),post[0]);
 const routes=['forum','forum/recent','forum/albums','forum/about','forum/webring',...data.groups.flatMap(g=>g.boards.map(b=>'forum/board/'+b.id)),...data.threads.map(t=>'forum/thread/'+t.id),...data.albums.flatMap(a=>['forum/album/'+a.id,...a.files.map((_,i)=>'forum/photo/'+encodeURIComponent(a.id+':'+i))]),...memberNames.map(m=>'forum/member/'+m)];
 const allowed=new Set(routes.map(r=>decodeURIComponent(r)));
 for(const route of routes){
  await page.goto(base+'/#'+route);
  await page.waitForFunction(()=>document.querySelector('#forum-main').innerHTML.length>0&&document.title!=='');
  // Wait for the fragment's own render, rather than the previous page's content.
  await page.waitForTimeout(30);
  assert(!(await page.locator('#forum-main').textContent()).includes('Transmission not found'),route);
  for(const target of await page.locator('a').evaluateAll(nodes=>nodes.map(n=>n.getAttribute('href')))){
   assert(target!=='#','placeholder link on '+route);
   if(target==='campaign.html'||target==='#forum-main')continue;
   assert(allowed.has(decodeURIComponent(target.slice(1))),route+' -> '+target);
  }
 }
 assert(!requests.some(url=>url.includes('supabase.co')||/\/(app|supabase-session|data|campaign-additions)\.js/.test(url)),'Public forum loaded campaign code/data');
 await page.goto(base+'/#forum/thread/cat-lawyer');await page.getByText('My client has been advised not to answer.',{exact:true}).waitFor();
 await page.goto(base+'/#forum/albums');await page.getByRole('link',{name:'Highly classified cat photographs'}).click();await page.getByRole('link',{name:'Open image 1',exact:false}).click();await page.getByText('Image cannot be displayed.',{exact:true}).waitFor();
 await page.getByRole('link',{name:'Moderator Control Panel'}).click();await page.locator('#signIn').waitFor();assert(page.url().endsWith('/campaign.html'));
 await page.goto(base+'/#people/alan-sovereign');await page.waitForURL('**/campaign.html#people/alan-sovereign');await page.locator('#signIn').waitFor();
 await page.goto(base+'/previews/verumdetenebris/');await page.waitForURL(base+'/#forum');
 await page.goto(base+'/#forum/unknown');await page.getByRole('heading',{name:'Transmission not found'}).waitFor();await page.getByRole('link',{name:'Return to the forum index',exact:true}).click();await page.getByText('Welcome, anonymous traveler.',{exact:true}).waitFor();
 await page.goto(base+'/#forum-main');assert(await page.locator('#forum-main .bar').count());
 const phone=await browser.newPage({viewport:{width:390,height:850},isMobile:true,hasTouch:true});await phone.goto(base+'/');
 assert.equal(await phone.locator('.page').evaluate(el=>getComputedStyle(el).width),'920px');assert(await phone.locator('.sidebar').isVisible());
 await phone.emulateMedia({reducedMotion:'reduce'});assert.equal(await phone.evaluate(()=>getComputedStyle(document.body,'::before').animationName),'none');
 await phone.emulateMedia({reducedMotion:'no-preference'});assert.equal(await phone.evaluate(()=>getComputedStyle(document.body,'::before').animationName),'background-twinkle');
 await phone.close();assert.deepEqual(errors,[]);await browser.close();console.log('PASS: '+routes.length+' fictional forum routes, all links, posts, albums/photos, moderator login, legacy campaign bookmarks, invalid routes, fixed desktop layout, and no Supabase requests from the public forum.');
})().catch(e=>{console.error(e);process.exit(1)});
