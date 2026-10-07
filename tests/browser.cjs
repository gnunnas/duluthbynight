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
   const hash = model.resolveRoute(raw);
   if (raw !== hash) return false;
   if (hash === 'app') return !!document.querySelector('main h1');
   const [path, query = ''] = hash.split('?');
   const parts = path.split('/');
   let id; try { id = parts[1] ? decodeURIComponent(parts[1]) : null; } catch { id = '__invalid__'; }
   return state.route === (parts.length > 2 ? '__invalid__' : parts[0]) && state.id === id && state.query === (new URLSearchParams(query).get('q') || '') && state.category === (new URLSearchParams(query).get('category') || null);
  });
 }

 await visit(baseURL);
 const records=await page.evaluate(()=>Object.entries(createCampaignModel(CAMPAIGN).collections).flatMap(([type,items])=>items.map(x=>[type,x.id,x.name||x.title])));
 const routes=['home','people','places','threads','organizations','clans','chronicle','schemes','events','disciplines','powers','search',...records.map(([type,id])=>type+'/'+id)];
 for(const width of [375,1280]) {
  await page.setViewportSize({width,height:900});
  for(const route of routes){
   await visit(baseURL + '/#'+route);
   assert.equal(await page.locator('main h1').count(),1,route);
   assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`overflow ${width} ${route}`);
   for(const href of await page.locator('main a').evaluateAll(nodes=>nodes.map(x=>x.getAttribute('href')))){
    const [type,id]=href.slice(1).split('?')[0].split('/');assert(routes.includes(type+(id?'/'+id:'')),`broken ${href}`);
   }
  }
 }
 for(const [type,id,title] of records){await visit(baseURL + '/#'+type+'/'+id);assert.equal(await page.locator('main h1').innerText(),title)}
 for(const [from,to] of [['people/kyra','places/bliss'],['people/chains','people/spokes'],['people/portia','threads/dark-mother'],['threads/dark-mother','chronicle/2026-09-11'],['people/kyra','organizations/duluth-camarilla'],['people/kyra','clans/toreador'],['people/chains','organizations/spokes-crew'],['organizations/bliss','places/bliss']]){
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
 assert.equal(await locations.locator('a[href="#places/watchtower"]').count(),0);
 assert.equal(await locations.locator('a[href="#places/bliss"]').count(),0);
 await visit(baseURL + '/#places/twig');
 assert.equal(await page.locator('main a[href="#places/watchtower"]').count(),1);
 assert.equal(await page.locator('main a[href="#places/bliss"]').count(),1);
 for (const id of ['watchtower','bliss']) {
  await visit(baseURL + '/#places/'+id);
  assert.deepEqual(await page.locator('.crumbs a').allTextContents(),['Places','Twig']);
 }
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
 for (const [legacy, current] of [['factions/spokes-crew','organizations/spokes-crew'],['factions/night-forum','organizations/night-forum'],['factions/bliss','organizations/bliss'],['groups/spokes-crew','organizations/spokes-crew'],['groups/night-forum','organizations/night-forum'],['groups/bliss','organizations/bliss'],['factions/duluth-camarilla','organizations/duluth-camarilla'],['groups','organizations?category=group'],['factions','organizations?category=political'],['factions/independent','search?q=Independent']]) {
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
 await visit(baseURL+'/#organizations/night-forum');
 assert.equal(await page.locator('[aria-label="Organization hierarchy"] a[href="#organizations/anarchs"]').count(),1);
 assert.equal(await page.locator('main a[href="#people/nora"]').count(),1);
 await visit(baseURL+'/#organizations/anarchs');
 assert.equal(await page.locator('main a[href="#organizations/night-forum"]').count(),1);
 assert.equal(await page.locator('main a[href="#people/nora"]').count(),0);
 await visit(baseURL+'/#people/nora');
 assert.match(await page.locator('main').innerText(),/Association/i);
 assert.equal(await page.locator('main a[href="#organizations/anarchs"]').count(),0);
 for(const query of ['Canal Park','The Rack']) {
  await visit(baseURL+'/#search?q='+encodeURIComponent(query));
  assert.equal(await page.locator('#searchResults a[href="#places/rack"]').count(),1);
 }
 await visit(baseURL+'/#places/rack');
 assert.equal(await page.locator('main h1').innerText(),'Canal Park · The Rack');
 assert.match(await page.locator('.facts').innerText(),/unconfirmed/i);
 // Independent browser check of inheritance using test-only normalized records.
 const inferred = await page.evaluate(() => {
  const fixture=structuredClone(CAMPAIGN);
  fixture.records.push({id:'person:test-member',recordType:'person',routeKey:'test-member',displayName:'Test-only member'});
  fixture.relationships.push({id:'test:member',relationshipType:'member_of',fromRecordId:'person:test-member',toRecordId:'organization:night-forum',knowledgeState:'recorded'});
  return createCampaignModel(fixture).membershipConnections('person:test-member');
 });
 assert.equal(inferred.length,2);
 assert.equal(inferred.find(x=>x.organizationId==='organization:anarchs').direct,false);
 await visit(baseURL+'/#people/alan-sovereign');
 const summary=await page.locator('.facts').innerText();
 for(const value of ['Kindred','Ventrue','Humanity','Generation','Blood Potency','Health','Willpower'])assert(summary.toLowerCase().includes(value.toLowerCase()));
 for(const value of ['Political affiliations','Ingrid Fallon','Associated places','Attributes','Skills','Disciplines'])assert(!summary.toLowerCase().includes(value.toLowerCase()));
 const mechanics=page.locator('.mechanics-panel');
 assert.equal(await mechanics.count(),3);
 assert.equal(await mechanics.filter({has:page.getByRole('heading',{name:'Attributes',exact:true})}).locator('.mechanic-entry').count(),9);
 assert.equal(await mechanics.filter({has:page.getByRole('heading',{name:'Skills',exact:true})}).locator('.mechanic-entry').count(),16);
 assert.equal(await mechanics.filter({has:page.getByRole('heading',{name:'Disciplines',exact:true})}).locator('.mechanic-entry').count(),4);
 assert.equal(await page.locator('.ability-list').count(),1);
 for(const title of ['Touchstones','Mask and Mien','Thralls and Tools','Relationships','Plots and Schemes','Whispers','Domain and Haven','Mortal History','Vampire History'])assert.equal(await page.getByRole('heading',{name:title,exact:true}).count(),1);
 assert.equal(await page.locator('main a[href="#organizations/camarilla"]').count(),1);
 // Selected ability rendering and text safety use browser-only fixtures, never campaign data.
 await page.evaluate(()=>{
  const discipline=CAMPAIGN.items.find(x=>x.recordId==='person:alan-sovereign'&&x.title==='Dominate');
  discipline.value.abilities=[{name:'Test-only power',notes:'<img src=x onerror=alert(1)>'}];
  render();
 });
 assert.equal(await page.locator('.ability-list').count(),2);
 assert.equal(await page.locator('.ability-list img').count(),0);
 assert((await page.locator('.ability-list').allInnerTexts()).join(' ').includes('<img'));
 await page.reload();
 await visit(baseURL+'/#people/marlon-falcone');
 assert.equal(await page.locator('.facts').count(),0);
 assert.equal(await page.locator('.npc-panel').count(),0);
 await visit(baseURL+'/#people/alan-sovereign');
 assert.equal(await page.locator('main a[href="#disciplines/dominate"]').count(),1);
 await page.locator('main a[href="#disciplines/dominate"]').click();
 await page.getByRole('heading',{name:'Dominate',exact:true}).waitFor();
 assert.equal(await page.locator('main a[href^="#people/"]').count(),0);
 await visit(baseURL+'/#disciplines/animalism');
 assert.equal(await page.locator('.npc-panel').count(),5);
 await page.locator('main a[href="#powers/animalism-sense-the-beast"]').click();
 await page.getByRole('heading',{name:'Sense The Beast',exact:true}).waitFor();
 assert((await page.locator('main').innerText()).includes('Resolve + Animalism vs Composure + Subterfuge'));
 assert.equal(await page.getByRole('heading',{name:'System',exact:true}).count(),1);
 await visit(baseURL+'/#search?q=Resonance');
 assert(await page.locator('main a[href="#powers/animalism-sense-the-beast"]').count());
 // NPC abilities open without changing route or losing place; native dialog traps focus.
 for(const width of [375,1280]){
  await page.setViewportSize({width,height:900});
  await visit(baseURL+'/#people/alan-sovereign');
  const trigger=page.locator('[data-ability-popup="power:auspex:heightened-senses"]');
  await trigger.click();
  const popup=page.getByRole('dialog',{name:'Heightened Senses',exact:true});
  await popup.waitFor();
  assert.equal(new URL(page.url()).hash,'#people/alan-sovereign');
  assert((await popup.innerText()).includes('Wits + Resolve'));
  assert((await popup.innerText()).includes('Free (but see below)'));
  assert((await popup.innerText()).includes('Until deactivated'));
  assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));
  await page.keyboard.press('Tab');
  assert(await page.evaluate(()=>document.querySelector('dialog').contains(document.activeElement)));
  await page.keyboard.press('Escape');
  assert.equal(await page.locator('dialog[open]').count(),0);
  assert(await trigger.evaluate(node=>node===document.activeElement));
  await trigger.click();await popup.waitFor();
  await page.mouse.click(2,2);
  assert.equal(await page.locator('dialog[open]').count(),0);
  assert.equal(new URL(page.url()).hash,'#people/alan-sovereign');
  await trigger.click();await popup.getByRole('button',{name:'Close ability reference'}).click();
  assert.equal(await page.locator('dialog[open]').count(),0);
  await trigger.click();await popup.getByRole('link',{name:'Open full ability page'}).click();
  await page.waitForURL('**/#powers/auspex-heightened-senses');
  await page.locator('main h1').filter({hasText:'Heightened Senses'}).waitFor();
  assert.equal(await page.locator('dialog[open]').count(),0);
  assert.equal(await page.locator('main a[href^="#people/"]').count(),0);
 }
 // Every pre-migration record route must still reach its retained identity.
 const migrationReport=require('../migration/phase-1-report.json');
 for(const [legacy,canonical] of Object.entries(migrationReport.routes)) {
  await visit(baseURL+'/#'+legacy);
  assert.equal(new URL(page.url()).hash,'#'+canonical);
  const identity=await page.evaluate(()=>by(state.route,state.id)?.recordId);
  const sourceKey=legacy.replace(/^chronicle\//,'sessions/');
  assert.equal(identity,migrationReport.idMap[sourceKey]);
 }
 assert.deepEqual(errors,[]);console.log(`PASS: ${routes.length} routes at mobile and desktop sizes; all record titles and rendered links; reciprocal links; hierarchy; search; invalid routes; mobile menu and browser back. No browser errors.`);await browser.close();
})().catch(e=>{console.error(e);process.exit(1)});
