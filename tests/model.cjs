const {test} = require('node:test');
const assert = require('node:assert/strict');
const vm = require('node:vm');
const fs = require('node:fs');
const path = require('node:path');
const {createCampaignModel} = require('../campaign-model.js');
const context = {window:{}};
vm.runInNewContext(fs.readFileSync(path.join(__dirname,'../data.js'),'utf8'),context);
const data = context.window.CAMPAIGN;
const model = createCampaignModel(data);
const ids = records => Array.from(records, record => record.id).sort();
test('IDs and recorded references are valid; geographic and organization parents are acyclic', () => {
 for (const [type, records] of Object.entries(model.collections)) {
  assert.equal(new Set(records.map(x=>x.id)).size, records.length, type);
  for (const record of records) {
   const seen = new Set([record.id]); let parentID = record.parent;
   while (parentID) {assert(!seen.has(parentID),type+' cycle');seen.add(parentID);const parent=model.by(type,parentID);assert(parent,type+' missing parent');parentID=parent.parent;}
   for (const [key] of Object.entries(model.collections)) {
    const field=key==='chronicle'?'sessions':key;
    if(Array.isArray(record[field])) for(const id of record[field]) assert(model.by(key,id),`${type}/${record.id} -> ${key}/${id}`);
   }
  }
 }
 for (const person of data.people) {
  assert(!('faction' in person) && !('related' in person) && !('place' in person));
  if(person.clan) assert(model.by('clans',person.clan));
  for(const item of person.memberships || []) assert(model.by('groups',item.group));
  for(const item of person.affiliations || []) assert(model.by('factions',item.faction));
 }
 for(const relation of data.relationships) {assert(model.by('people',relation.from));assert(model.by('people',relation.to));}
});
test('clan does not propagate through group or personal associations', () => {
 assert.deepEqual(ids(model.related('clans',model.by('clans','nosferatu')).people),['spokes']);
 assert.deepEqual(ids(model.related('people',model.by('people','chains')).clans),[]);
 assert.deepEqual(ids(model.related('groups',model.by('groups','spokes-crew')).people),['big-chain','chains','freewheel','pedals','spokes']);
});
test('Independent is a searchable status, not an organization', () => {
 assert(!model.by('groups','independent') && !model.by('factions','independent'));
 const person=model.by('people','sydney');assert.equal(person.affiliationStatus,'Independent');
 assert(model.searchText('people',person).includes('independent'));
});
test('typed relationships resolve both directions without assigning roles', () => {
 assert(ids(model.related('people',model.by('people','chains')).people).includes('spokes'));
 assert(ids(model.related('people',model.by('people','spokes')).people).includes('chains'));
 for(const relationship of data.relationships) {assert.equal(relationship.kind,'association');assert.equal(relationship.label,null);}
});
test('multiple groups and political affiliations remain independent of clan', () => {
 // Test-only records; not campaign lore.
 const fixture = {people:[{id:'test-person',memberships:[{group:'test-group-1',role:'Test role'},{group:'test-group-2',role:null}],affiliations:[{faction:'test-faction-1'},{faction:'test-faction-2'}]}],groups:[{id:'test-group-1',name:'Test Group 1'},{id:'test-group-2',name:'Test Group 2',parent:'test-group-1'}],factions:[{id:'test-faction-1'},{id:'test-faction-2'}],clans:[],places:[],threads:[],sessions:[],relationships:[]};
 const fixtureModel=createCampaignModel(fixture);
 const related=fixtureModel.related('people',fixture.people[0]);
 assert.equal(related.groups.length,2);assert.equal(related.factions.length,2);assert.equal(related.clans.length,0);
 for(const group of fixture.groups) assert.deepEqual(ids(fixtureModel.related('groups',group).people),['test-person']);
 assert(fixtureModel.searchText('people',fixture.people[0]).includes('test role'));
});
