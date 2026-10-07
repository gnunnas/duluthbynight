const {test}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const {createCampaignModel,validateCampaign}=require('../campaign-model.js');
const context={window:{}};
for(const file of ['data.js','campaign-additions.js','discipline-data.js'])vm.runInNewContext(fs.readFileSync(path.join(__dirname,'..',file),'utf8'),context);
const data=JSON.parse(JSON.stringify(context.window.CAMPAIGN));
const model=createCampaignModel(data),A='person:alan-sovereign';
const items=model.itemsFor(A);
test('authored public additions and all links validate against the frozen baseline',()=>{
 assert.deepEqual(validateCampaign(data),[]);assert.equal(data.records.length,70);
 assert(data.sources.some(x=>x.id==='source:alan-public-note'));
 assert.equal(model.by('people','alan-sovereign').type,'Kindred');assert.equal(model.by('people','alan-sovereign').clan,'ventrue');
});
test('overview ratings exactly match the approved note',()=>{
 const expected={'person.humanity':5,'person.generation':'9th','person.bloodPotency':3,'person.health':6,'person.willpower':4};
 for(const [key,value] of Object.entries(expected))assert.equal(items.find(x=>x.fieldKey===key).value,value);
});
test('individual attributes, skills, and specialties are preserved without filling unlisted scores',()=>{
 const attributes=items.filter(x=>x.fieldKey==='mechanics.attribute');assert.equal(attributes.length,9);
 assert.deepEqual(Object.fromEntries(attributes.map(x=>[x.title,x.value.rating])),{Strength:1,Dexterity:3,Stamina:3,Charisma:3,Manipulation:5,Composure:2,Intelligence:5,Wits:3,Resolve:2});
 const skills=items.filter(x=>x.fieldKey==='mechanics.skill');assert.equal(skills.length,16);
 assert.deepEqual(skills.find(x=>x.title==='Finance').value,{rating:5,specialties:['Stock Market']});
 assert.deepEqual(skills.find(x=>x.title==='Technology').value,{rating:2,specialties:['Computers']});
 assert(!skills.some(x=>x.title==='Athletics'));
});
test('discipline ratings do not imply selected powers or fabricated reference records',()=>{
 const disciplines=items.filter(x=>x.fieldKey==='mechanics.discipline');
 assert.deepEqual(Object.fromEntries(disciplines.map(x=>[x.title,x.value.rating])),{Auspex:2,Dominate:4,Fortitude:3,Presence:2});
 for(const discipline of disciplines){assert.deepEqual(discipline.value.abilities,discipline.title==='Auspex'?[{recordId:'power:auspex:heightened-senses'}]:[]);assert.equal(discipline.value.referenceRecordId,'discipline:'+discipline.title.toLowerCase());}
});
test('narratives, individual schemes, and rumors retain their sections and qualifiers',()=>{
 const sections=model.sectionsFor(A);
 for(const key of ['convictions','touchstones','mask-and-mien','thralls-and-tools','relationships','plots','whispers','domain-and-haven','mortal-history','vampire-history'])assert(sections.some(x=>x.templateKey===key));
 const plots=sections.find(x=>x.templateKey==='plots');assert.equal(items.filter(x=>x.sectionId===plots.id&&!x.parentItemId).length,4);
 const whispers=sections.find(x=>x.templateKey==='whispers');assert(items.filter(x=>x.sectionId===whispers.id).every(x=>x.knowledgeState==='rumor'));
 assert(items.some(x=>x.body?.includes('Born 1903')));assert(items.some(x=>x.body?.includes('Embraced in 1959')));
});
test('specific relationships have reciprocal structure without mirroring private attitudes',()=>{
 assert(model.related('people',model.by('people','horatio-ballard')).people.some(x=>x.recordId===A));
 assert.equal(model.personalRelationships(A).find(x=>x.kind==='sire_of').label,'Childe of');
 assert.equal(model.personalRelationships('person:horatio-ballard').find(x=>x.kind==='sire_of').label,'Sire of');
 const hatred=items.find(x=>x.title?.includes('Hatred'));assert.equal(hatred.perspectiveRecordId,A);
 assert(!model.itemsFor('person:horatio-ballard').some(x=>x.title?.includes('Hatred')));
});
test('minimal referenced NPCs stay sparse and locations retain unknown containing areas',()=>{
 const marlon=model.by('people','marlon-falcone');assert.equal(marlon.type,undefined);assert.equal(marlon.clan,undefined);
 for(const key of ['alan-east-duluth-townhouse','loop'])assert.equal(model.by('places',key).parent,undefined);
 const claim=data.domainClaims.find(x=>x.id==='claim:alan:loop');assert.equal(claim.claimantRecordId,A);assert.equal(claim.status,'asserted');
 assert(!data.relationships.some(x=>x.fromRecordId===A&&x.relationshipType==='owns'));
});
test('nickname and mechanics specialties are searchable; malformed references are rejected',()=>{
 const person=model.byId(A);assert(model.searchText('people',person).includes('the money'));assert(model.searchText('people',person).includes('stock market'));
 // Searchable mechanics title/specialty support keeps the content useful without generating lore.
 const fixture=structuredClone(data);fixture.items.find(x=>x.recordId===A&&x.title==='Dominate').value.abilities=[{name:'Test',recordId:'power:missing'}];
 assert(validateCampaign(fixture).some(x=>x.includes('Missing ability reference')));
});
test('discipline library preserves level hierarchy and supplied rules without filling missing text',()=>{
 const animalism=model.by('disciplines','animalism');assert(animalism);
 const powers=model.collections.powers.filter(x=>x.disciplineId===animalism.recordId);
 assert.deepEqual([1,2,3,4,5].map(level=>powers.filter(x=>x.level===level).length),[2,2,5,2,2]);
 const sense=model.by('powers','animalism-sense-the-beast');assert.equal(sense.level,1);
 const fields=model.itemsFor(sense.recordId);assert.equal(fields.find(x=>x.fieldKey==='power.cost').body,'Free');assert.equal(fields.find(x=>x.fieldKey==='power.duration').body,'Passive');
 assert(fields.find(x=>x.fieldKey==='power.system').body.includes('their Resonance'));
 assert(!fields.some(x=>x.fieldKey==='power.notes'));
 assert.equal(model.by('powers','animalism-bond-famulus').summary,undefined);
 assert(model.searchText('powers',sense).includes('resolve + animalism'));
});
test('selected abilities link both ways and reject wrong discipline, level, and parent',()=>{
 const fixture=structuredClone(data), id='power:animalism:sense-the-beast';
 fixture.items.push({id:'item:test:animalism',recordId:A,sectionId:items.find(x=>x.fieldKey==='mechanics.discipline').sectionId,itemKind:'mechanic',fieldKey:'mechanics.discipline',title:'Animalism',value:{rating:1,referenceRecordId:'discipline:animalism',abilities:[{recordId:id}]}});
 const linked=createCampaignModel(fixture);
 assert(linked.related('powers',linked.byId(id)).people.some(x=>x.recordId===A));
 assert(linked.related('disciplines',linked.byId('discipline:animalism')).people.some(x=>x.recordId===A));
 assert(linked.related('people',linked.byId(A)).powers.some(x=>x.recordId===id));
 fixture.items.at(-1).value.referenceRecordId='discipline:dominate';assert(validateCampaign(fixture).some(x=>x.includes('Ability discipline mismatch')));
 fixture.items.at(-1).value.referenceRecordId='discipline:animalism';fixture.items.at(-1).value.rating=0;assert(validateCampaign(fixture).some(x=>x.includes('Ability exceeds discipline rating')));
 fixture.relationships=fixture.relationships.filter(x=>x.fromRecordId!==id);assert(validateCampaign(fixture).some(x=>x.includes('exactly one discipline')));
});
test('Alan explicitly has supplied level 1 Heightened Senses with reciprocal reference',()=>{
 const ability=model.by('powers','auspex-heightened-senses');assert.equal(ability.level,1);assert.equal(ability.disciplineId,'discipline:auspex');
 const fields=model.itemsFor(ability.recordId);
 assert.equal(fields.find(x=>x.fieldKey==='power.cost').body,'Free (but see below)');
 assert.equal(fields.find(x=>x.fieldKey==='power.dicePools').body,'Wits + Resolve');
 assert(fields.find(x=>x.fieldKey==='power.system').body.includes('-3 dice penalty'));
 assert(fields.find(x=>x.fieldKey==='power.duration').body.includes('Until deactivated'));
 assert(model.related('powers',ability).people.some(x=>x.recordId===A));
});
