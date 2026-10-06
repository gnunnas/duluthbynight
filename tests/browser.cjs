const {chromium}=require('playwright');
const assert=require('node:assert/strict');
const baseURL = process.env.CAMPAIGN_TEST_URL || 'http://127.0.0.1:8000';
(async()=>{
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH || undefined,headless:true,args:['--no-sandbox']});
 const page=await browser.newPage(); const errors=[];page.on('pageerror',e=>errors.push(e.message));
 await page.goto(baseURL);
 const records=await page.evaluate(()=>Object.entries({people:CAMPAIGN.people,places:CAMPAIGN.places,threads:CAMPAIGN.threads,factions:CAMPAIGN.factions,chronicle:CAMPAIGN.sessions}).flatMap(([type,items])=>items.map(x=>[type,x.id,x.name||x.title])));
 const routes=['home','people','places','threads','factions','chronicle','search',...records.map(([type,id])=>type+'/'+id)];
 for(const width of [375,1280]) {
  await page.setViewportSize({width,height:900});
  for(const route of routes){
   await page.goto(baseURL + '/#'+route);
   assert.equal(await page.locator('main h1').count(),1,route);
   assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`overflow ${width} ${route}`);
   for(const href of await page.locator('main a').evaluateAll(nodes=>nodes.map(x=>x.getAttribute('href')))){
    const [type,id]=href.slice(1).split('/');assert(routes.includes(type+(id?'/'+id:'')),`broken ${href}`);
   }
  }
 }
 for(const [type,id,title] of records){await page.goto(baseURL + '/#'+type+'/'+id);assert.equal(await page.locator('main h1').innerText(),title)}
 for(const [from,to] of [['people/kyra','places/bliss'],['people/chains','people/spokes'],['people/portia','threads/dark-mother'],['threads/dark-mother','chronicle/2026-09-11'],['people/kyra','factions/duluth-camarilla']]){
  await page.goto(baseURL + '/#'+from);await page.locator('main a[href="#'+to+'"]').first().click();await page.waitForURL('**/#'+to);await page.waitForFunction(expected => document.querySelector('main h1')?.textContent === expected, records.find(([type,id])=>type+'/'+id===to)[2]);assert(await page.locator('main a[href="#'+from+'"]').count(),`missing reverse ${to} -> ${from}`);
 }
 await page.goto(baseURL + '/#places/duluth');
 assert.equal(await page.locator('section').filter({has:page.getByRole('heading',{name:'Districts & neighborhoods'})}).locator('a.card').count(),2);
 assert.equal(await page.locator('section').filter({has:page.getByRole('heading',{name:'Individual locations'})}).locator('a.card').count(),1);
 await page.goto(baseURL + '/#places/chantry');assert.deepEqual(await page.locator('.crumbs a').allTextContents(),['Places','Superior','Billings Park']);
 await page.goto(baseURL + '/#search');await page.getByRole('searchbox').fill('portia');assert(await page.locator('#searchResults a').count()>=3);await page.reload();assert.equal(await page.getByRole('searchbox').inputValue(),'portia');
 await page.getByRole('searchbox').fill('nonexistent record');assert.equal(await page.locator('#searchResults a').count(),0);
 await page.getByRole('searchbox').fill('<img src=x onerror=alert(1)>');assert.equal(await page.locator('#searchResults img').count(),0);
 for(const route of ['unknown','people/missing','people/%ZZ','people/kyra/extra']){await page.goto(baseURL + '/#'+route);assert.equal(await page.locator('main h1').innerText(),'Record not found')}
 await page.setViewportSize({width:375,height:812});await page.goto(baseURL + '/#home');await page.getByRole('button',{name:'Open navigation'}).click();assert.equal(await page.locator('#menuBtn').getAttribute('aria-expanded'),'true');await page.locator('#nav a[href="#people"]').click();await page.waitForURL('**/#people');await page.waitForFunction(()=>document.querySelector('main h1')?.textContent==='People');assert.equal(await page.locator('#menuBtn').getAttribute('aria-expanded'),'false');await page.goBack();await page.waitForFunction(()=>document.querySelector('.hero')!==null);assert.equal(await page.locator('main h1').innerText(),'DULUTH\nBY NIGHT');
 await page.locator('.brand').click();await page.waitForFunction(()=>document.querySelector('.hero')!==null);
 await page.goto(baseURL+'/#app');assert.equal(await page.locator('.hero').count(),1);
 assert.deepEqual(errors,[]);console.log(`PASS: ${routes.length} routes at mobile and desktop sizes; all record titles and rendered links; reciprocal links; hierarchy; search; invalid routes; mobile menu and browser back. No browser errors.`);await browser.close();
})().catch(e=>{console.error(e);process.exit(1)});
