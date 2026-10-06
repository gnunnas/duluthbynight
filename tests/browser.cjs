const {chromium}=require('playwright');
const assert=require('node:assert/strict');
const baseURL = process.env.CAMPAIGN_TEST_URL || 'http://127.0.0.1:8000';
(async()=>{
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH || undefined,headless:true,args:['--no-sandbox']});
 const page=await browser.newPage(); const errors=[];page.on('pageerror',e=>errors.push(e.message));
 async function visit(targetURL) {
  await page.goto(targetURL);
  // Fragment navigation finishes before hashchange renders; wait for the route state.
  await page.waitForFunction(() => {
   const raw = location.hash.slice(1) || 'home';
   const hash = CAMPAIGN.legacyRoutes[raw] || raw;
   if (raw !== hash) return false;
   if (hash === 'app') return !!document.querySelector('main h1');
   const [path, query = ''] = hash.split('?');
   const parts = path.split('/');
   let id; try { id = parts[1] ? decodeURIComponent(parts[1]) : null; } catch { id = '__invalid__'; }
   return state.route === (parts.length > 2 ? '__invalid__' : parts[0]) && state.id === id && state.query === (new URLSearchParams(query).get('q') || '');
  });
 }

 await visit(baseURL);
 const records=await page.evaluate(()=>Object.entries(createCampaignModel(CAMPAIGN).collections).flatMap(([type,items])=>items.map(x=>[type,x.id,x.name||x.title])));
 const routes=['home','people','places','threads','factions','groups','clans','chronicle','search',...records.map(([type,id])=>type+'/'+id)];
 for(const width of [375,1280]) {
  await page.setViewportSize({width,height:900});
  for(const route of routes){
   await visit(baseURL + '/#'+route);
   assert.equal(await page.locator('main h1').count(),1,route);
   assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`overflow ${width} ${route}`);
   for(const href of await page.locator('main a').evaluateAll(nodes=>nodes.map(x=>x.getAttribute('href')))){
    const [type,id]=href.slice(1).split('/');assert(routes.includes(type+(id?'/'+id:'')),`broken ${href}`);
   }
  }
 }
 for(const [type,id,title] of records){await visit(baseURL + '/#'+type+'/'+id);assert.equal(await page.locator('main h1').innerText(),title)}
 for(const [from,to] of [['people/kyra','places/bliss'],['people/chains','people/spokes'],['people/portia','threads/dark-mother'],['threads/dark-mother','chronicle/2026-09-11'],['people/kyra','factions/duluth-camarilla'],['people/kyra','clans/toreador'],['people/chains','groups/spokes-crew'],['groups/bliss','places/bliss']]){
  await visit(baseURL + '/#'+from);await page.locator('main a[href="#'+to+'"]').first().click();await page.waitForURL('**/#'+to);await page.waitForFunction(expected => document.querySelector('main h1')?.textContent === expected, records.find(([type,id])=>type+'/'+id===to)[2]);await page.locator('main a[href="#'+from+'"]').first().waitFor();assert(await page.locator('main a[href="#'+from+'"]').count(),`missing reverse ${to} -> ${from}`);
 }
 await visit(baseURL + '/#places/duluth');
 assert.equal(await page.locator('section').filter({has:page.getByRole('heading',{name:'Geographic areas'})}).locator('a.card').count(),3);
 assert.equal(await page.locator('main a[href="#places/nopeming"]').count(),0);
 await visit(baseURL + '/#places/eldes-corner');
 assert.equal(await page.locator('section').filter({has:page.getByRole('heading',{name:'Individual locations'})}).locator('a.card').count(),1);
 await page.locator('main a[href="#places/nopeming"]').click();
 await page.waitForFunction(()=>document.querySelector('main h1')?.textContent==='Nopeming Sanatorium');
 assert.deepEqual(await page.locator('.crumbs a').allTextContents(),['Places','Duluth','Eldes Corner']);
 assert.equal(await page.locator('main a[href="#threads/dark-mother"]').count(),1);
 await visit(baseURL + '/#places/downtown');
 const geography = page.locator('section').filter({has:page.getByRole('heading',{name:'Geographic areas'})});
 const locations = page.locator('section').filter({has:page.getByRole('heading',{name:'Individual locations'})});
 assert.equal(await geography.locator('a[href="#places/rack"]').count(),1);
 assert.equal(await locations.locator('a[href="#places/rack"]').count(),0);
 assert.equal(await locations.locator('a[href="#places/watchtower"]').count(),1);
 await visit(baseURL + '/#places/watchtower');
 const facts = await page.locator('.facts').innerText();
 assert(facts.includes('Building') && facts.includes('Recorded claim') && facts.includes('Unknown'));
 await visit(baseURL + '/#places/chantry');assert.deepEqual(await page.locator('.crumbs a').allTextContents(),['Places','Superior','Billings Park']);
 await visit(baseURL + '/#people/chains');
 assert.match(await page.locator('.facts').innerText(), /Clan\s+Unknown/i);
 assert.equal(await page.locator('main a[href="#clans/nosferatu"]').count(),0);
 await visit(baseURL + '/#people/sydney');
 assert.match(await page.locator('.facts').innerText(), /Affiliation status\s+Independent/i);
 assert.equal(await page.locator('main a[href="#factions/independent"]').count(),0);
 for (const [legacy, current] of [['factions/spokes-crew','groups/spokes-crew'],['factions/night-forum','groups/night-forum'],['factions/bliss','groups/bliss'],['factions/independent','search?q=Independent']]) {
  await visit(baseURL + '/#'+legacy);assert.equal(new URL(page.url()).hash,'#'+current);
 }
 await visit(baseURL + '/#search?q=Toreador');
 assert.equal(await page.locator('#searchResults a[href="#people/kyra"]').count(),1);
 assert.equal(await page.locator('#searchResults a[href="#clans/toreador"]').count(),1);
 await visit(baseURL + '/#search');await page.getByRole('searchbox').fill('portia');assert(await page.locator('#searchResults a').count()>=3);await page.reload();assert.equal(await page.getByRole('searchbox').inputValue(),'portia');
 await page.getByRole('searchbox').fill('nonexistent record');assert.equal(await page.locator('#searchResults a').count(),0);
 await page.getByRole('searchbox').fill('<img src=x onerror=alert(1)>');assert.equal(await page.locator('#searchResults img').count(),0);
 for(const route of ['unknown','people/missing','people/%ZZ','people/kyra/extra']){await visit(baseURL + '/#'+route);assert.equal(await page.locator('main h1').innerText(),'Record not found')}
 await page.setViewportSize({width:375,height:812});await visit(baseURL + '/#home');await page.getByRole('button',{name:'Open navigation'}).click();assert.equal(await page.locator('#menuBtn').getAttribute('aria-expanded'),'true');await page.locator('#nav a[href="#people"]').click();await page.waitForURL('**/#people');await page.waitForFunction(()=>document.querySelector('main h1')?.textContent==='People');assert.equal(await page.locator('#menuBtn').getAttribute('aria-expanded'),'false');await page.goBack();await page.waitForFunction(()=>document.querySelector('.hero')!==null);assert.equal(await page.locator('main h1').innerText(),'DULUTH\nBY NIGHT');
 await page.locator('.brand').click();await page.waitForFunction(()=>document.querySelector('.hero')!==null);
 await visit(baseURL+'/#app');assert.equal(await page.locator('.hero').count(),1);
 // Temporary browser-only fixtures validate unpopulated capabilities without adding lore.
 await page.evaluate(() => {
  CAMPAIGN.groups.push({id:'test-parent',name:'Test parent'}, {id:'test-child',name:'Test child',parent:'test-parent'});
  CAMPAIGN.people.push({id:'test-person',name:'Test person',type:'Mortal',memberships:[{group:'test-parent',role:'Test role'}, {group:'test-child',role:null}]});
  location.hash = 'groups/test-parent';
 });
 await page.waitForFunction(()=>document.querySelector('main h1')?.textContent==='Test parent');
 assert.equal(await page.locator('main a[href="#groups/test-child"]').count(),1);
 await page.locator('main a[href="#groups/test-child"]').click();
 await page.waitForFunction(()=>document.querySelector('main h1')?.textContent==='Test child');
 assert.equal(await page.locator('[aria-label="Organization hierarchy"] a[href="#groups/test-parent"]').count(),1);
 await page.locator('main a[href="#people/test-person"]').click();
 await page.waitForFunction(()=>document.querySelector('main h1')?.textContent==='Test person');
 assert.match(await page.locator('.facts').innerText(), /Test role/i);
 assert.match(await page.locator('.facts').innerText(), /Clan\s+Not applicable/i);
 assert.equal(await page.locator('main a[href="#groups/test-child"]').count(),2);
 await page.reload(); // Discard the test-only records.
 assert.deepEqual(errors,[]);console.log(`PASS: ${routes.length} routes at mobile and desktop sizes; all record titles and rendered links; reciprocal links; hierarchy; search; invalid routes; mobile menu and browser back. No browser errors.`);await browser.close();
})().catch(e=>{console.error(e);process.exit(1)});
