const {test}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const vm=require('node:vm');
const path=require('node:path');
const {createCampaignModel,validateCampaign}=require('../campaign-model.js');
function load(file){const context={window:{}};vm.runInNewContext(fs.readFileSync(path.join(__dirname,'..',file),'utf8'),context);return JSON.parse(JSON.stringify(context.window.CAMPAIGN));}
const data=load('data.js'), source=load('migration/phase-1-source.js');
const report=JSON.parse(fs.readFileSync(path.join(__dirname,'../migration/phase-1-report.json'),'utf8'));
const model=createCampaignModel(data);
const ids=records=>records.map(x=>x.recordId).sort();
const clone=()=>structuredClone(data);
function testPerson(fixture,id='fixture-person'){
 fixture.records.push({id:`person:${id}`,recordType:'person',routeKey:id,displayName:'Test-only person'});
 return `person:${id}`;
}
function membership(fixture,person,organization,type='member_of',extra={}){
 fixture.relationships.push({id:`test:${person}:${organization}:${type}`,relationshipType:type,fromRecordId:person,toRecordId:organization,knowledgeState:'recorded',...extra});
}
test('normalized data validates; globally unique identities distinguish premises and organizations',()=>{
 assert.deepEqual(validateCampaign(data),[]);
 assert.equal(data.records.length,41);
 assert(model.byId('place:bliss'));assert(model.byId('organization:bliss'));
 assert.notEqual(model.byId('place:bliss').recordId,model.byId('organization:bliss').recordId);
 assert(!('people' in data)&&!('groups' in data)&&!('factions' in data));
});
test('all source records and routes are retained, with only the documented overview change',()=>{
 for(const collection of ['people','places','clans','groups','factions','threads','sessions'])for(const record of source[collection]){
  const id=report.idMap[`${collection}/${record.id}`];assert(model.byId(id),id);
  const originalRoute=(collection==='sessions'?'chronicle':collection)+'/'+record.id;
  const canonical=model.resolveRoute(originalRoute);assert.equal(canonical,report.routes[originalRoute]);
  const [type,key]=canonical.split('/');assert.equal(model.by(type,key).recordId,id);
  if(record.summary){
   if(id==='place:rack')assert.equal(report.semanticChanges.find(x=>x.recordId===id).originalOverview,record.summary);
   else assert.equal(model.byId(id).summary,record.summary,id);
  }
 }
 assert.equal(data.records.length,Object.values(report.sourceCounts).reduce((a,b)=>a+b,0)+1);
});
test('all old person/place/clan and campaign references preserve their connections',()=>{
 for(const person of source.people){
  const id=report.idMap['people/'+person.id],related=model.related('people',model.byId(id));
  for(const place of person.places||[])assert(ids(related.places).includes('place:'+place));
  if(person.clan)assert(ids(related.clans).includes('clan:'+person.clan));
  for(const connection of [...(person.memberships||[]),...(person.affiliations||[])])assert(ids(related.organizations).includes('organization:'+(connection.group||connection.faction)));
 }
 for(const [collection,route] of [['threads','threads'],['sessions','chronicle']])for(const record of source[collection]){
  const related=model.related(route,model.byId(report.idMap[`${collection}/${record.id}`]));
  for(const field of ['people','places','threads'])for(const id of record[field]||[])assert(related[field].some(x=>x.id===id));
 }
 for(const connection of source.relationships){assert(ids(model.related('people',model.by('people',connection.from)).people).includes('person:'+connection.to));assert(ids(model.related('people',model.by('people',connection.to)).people).includes('person:'+connection.from));}
});
test('homepage fields and references are preserved and children are derived only from containment',()=>{
 assert.deepEqual(model.tonight,source.tonight);
 for(const place of source.places)assert.equal(model.by('places',place.id).parent,place.parent);
 assert.equal(model.by('places','watchtower').parent,'twig');assert.equal(model.by('places','bliss').parent,'twig');
 assert.equal(model.by('places','nopeming').parent,'eldes-corner');
 assert(!data.records.some(x=>'children' in x||'parent' in x));
});
test('contextual aliases find one Canal Park/The Rack record; legacy parent remains flagged',()=>{
 const rack=model.by('places','rack');
 assert.equal(rack.name,'Canal Park · The Rack');
 assert(model.searchText('places',rack).includes('canal park'));assert(model.searchText('places',rack).includes('the rack'));
 assert.equal(data.names.filter(x=>x.recordId==='place:rack').length,2);
 assert.equal(rack.parent,'downtown');assert(rack.reviewIssues.length);
 assert.equal(data.relationships.find(x=>x.fromRecordId==='place:rack'&&x.relationshipType==='contained_in').knowledgeState,'unverified');
 assert(!rack.summary.includes('tunnel network'));
});
test('association, clan, Independent, and unknown claim retain their distinct meaning',()=>{
 assert.deepEqual(ids(model.related('clans',model.by('clans','nosferatu')).people),['person:spokes']);
 assert.deepEqual(model.related('people',model.by('people','chains')).clans,[]);
 assert.equal(model.by('people','sydney').affiliationStatus,'Independent');assert(!model.by('organizations','independent'));
 assert(model.searchText('people',model.by('people','sydney')).includes('independent'));
 for(const id of ['person:nora','person:georgia'])assert(data.relationships.some(x=>x.fromRecordId===id&&x.relationshipType==='associate_of'));
 assert.equal(data.domainClaims[0].claimantRecordId,null);assert.equal(data.domainClaims[0].status,'unspecified');
 assert(!data.relationships.some(x=>x.relationshipType==='owns'));
});
test('confirmed member inherits Anarch affiliation once, with provenance; no reverse inheritance',()=>{
 const fixture=clone(),person=testPerson(fixture);membership(fixture,person,'organization:night-forum');
 const testModel=createCampaignModel(fixture),connections=testModel.membershipConnections(person);
 assert.equal(connections.length,2);
 const anarch=connections.find(x=>x.organizationId==='organization:anarchs');
 assert.equal(anarch.direct,false);assert.deepEqual(anarch.paths[0].organizationIds,['organization:night-forum','organization:anarchs']);
 assert.deepEqual(anarch.paths[0].implicationIds,['implication:night-forum:anarchs']);
 assert(ids(testModel.related('organizations',testModel.by('organizations','anarchs')).people).includes(person));
 const reverse=clone(),other=testPerson(reverse);membership(reverse,other,'organization:anarchs');
 assert.equal(createCampaignModel(reverse).membershipConnections(other).length,1);
});
test('associate/uncertain membership does not derive affiliation; current Nora is not upgraded',()=>{
 assert.equal(model.membershipConnections('person:nora').length,1);
 assert.deepEqual(model.related('organizations',model.by('organizations','anarchs')).people,[]);
 for(const [type,state] of [['associate_of','recorded'],['member_of','rumor']]){
  const fixture=clone(),person=testPerson(fixture);membership(fixture,person,'organization:night-forum',type,{knowledgeState:state});
  assert.equal(createCampaignModel(fixture).membershipConnections(person).length,1);
 }
});
test('direct and inherited connections deduplicate rosters without losing provenance',()=>{
 const fixture=clone(),person=testPerson(fixture);membership(fixture,person,'organization:night-forum');membership(fixture,person,'organization:anarchs');
 const testModel=createCampaignModel(fixture),anarch=testModel.membershipConnections(person).find(x=>x.organizationId==='organization:anarchs');
 assert.equal(anarch.direct,true);assert.equal(anarch.paths.length,2);
 assert.equal(testModel.related('organizations',testModel.by('organizations','anarchs')).people.filter(x=>x.recordId===person).length,1);
});
test('multiple memberships/affiliations and dated membership derivation work independently of clan',()=>{
 const fixture=clone(),person=testPerson(fixture);
 membership(fixture,person,'organization:night-forum','member_of',{validFrom:{start:'2020-01-01'},validUntil:{end:'2021-12-31'}});
 membership(fixture,person,'organization:spokes-crew');membership(fixture,person,'organization:duluth-camarilla','affiliated_with');
 const testModel=createCampaignModel(fixture);
 assert.equal(testModel.membershipConnections(person).length,3);
 assert.equal(testModel.membershipConnections(person,{atDate:'2021-06-01'}).length,4);
 assert.equal(testModel.membershipConnections(person,{atDate:'2022-06-01'}).length,3);
 assert.deepEqual(testModel.related('people',testModel.byId(person)).clans,[]);
});
test('directed personal relationships produce distinct forward/reverse labels',()=>{
 const fixture=clone();fixture.relationships.push({id:'test:sire',relationshipType:'sire_of',fromRecordId:'person:spokes',toRecordId:'person:chains',knowledgeState:'recorded'});
 const testModel=createCampaignModel(fixture);
 assert.equal(testModel.personalRelationships('person:spokes').find(x=>x.kind==='sire_of').label,'Sire of');
 assert.equal(testModel.personalRelationships('person:chains').find(x=>x.kind==='sire_of').label,'Childe of');
});
test('validators reject invalid endpoints, duplicate symmetric links, hierarchy cycles and multiple parents',()=>{
 const variants=[
  fixture=>fixture.relationships[0].toRecordId='person:missing',
  fixture=>fixture.relationships[0].toRecordId='place:twig',
  fixture=>fixture.relationships.push({id:'test:duplicate',relationshipType:'associated_with',fromRecordId:'person:chains',toRecordId:'person:spokes'}),
  fixture=>fixture.relationships.push({id:'test:cycle',relationshipType:'contained_in',fromRecordId:'place:duluth',toRecordId:'place:eldes-corner'}),
  fixture=>fixture.relationships.push({id:'test:parent',relationshipType:'contained_in',fromRecordId:'place:watchtower',toRecordId:'place:duluth'}),
  fixture=>fixture.membershipImplications.push({id:'test:cycle',enabled:true,sourceOrganizationId:'organization:anarchs',targetOrganizationId:'organization:night-forum',eligibleConnectionTypes:['member_of']}),
  fixture=>fixture.routeAliases['organizations/anarchs']='groups/night-forum',
  fixture=>fixture.records[0].campaignId='other-campaign'
 ];
 // Route-alias case explicitly closes a loop through an existing alias.
 variants[6]=fixture=>{fixture.routeAliases['organizations/night-forum']='groups/night-forum';};
 for(const mutate of variants){const fixture=clone();mutate(fixture);assert(validateCampaign(fixture).length);assert.throws(()=>createCampaignModel(fixture));}
});
test('minimal records and nested custom entries are valid without invented facts',()=>{
 const fixture=clone(),person=testPerson(fixture,'minor');
 fixture.sections.push({id:'test:section',recordId:person,heading:'Custom notes'});
 fixture.items.push({id:'test:parent-item',recordId:person,sectionId:'test:section',itemKind:'note',body:'Test-only note'},{id:'test:child-item',recordId:person,sectionId:'test:section',parentItemId:'test:parent-item',itemKind:'note',body:'Test-only detail'});
 assert.deepEqual(validateCampaign(fixture),[]);const record=createCampaignModel(fixture).byId(person);
 assert.equal(record.type,undefined);assert.equal(record.clan,undefined);assert.equal(record.summary,undefined);
 fixture.items.at(-2).parentItemId='test:child-item';assert(validateCampaign(fixture).some(x=>x.includes('item nesting cycle')));
});

test('old route aliases preserve query parameters and category defaults',()=>{
 assert.equal(model.resolveRoute('groups/night-forum?q=night'),'organizations/night-forum?q=night');
 assert.equal(model.resolveRoute('groups?q=night'),'organizations?q=night&category=group');
 assert.equal(model.resolveRoute('factions?category=group'),'organizations?category=political');
});
