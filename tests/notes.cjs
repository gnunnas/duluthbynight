const {test}=require('node:test'),assert=require('node:assert/strict');
const fs=require('node:fs'),vm=require('node:vm'),path=require('node:path');
const {createCampaignModel,validateCampaign}=require('../campaign-model.js');
const context={window:{}};
for(const file of ['data.js','campaign-additions.js','discipline-data.js','watchtower-data.js','source-notes.js'])vm.runInNewContext(fs.readFileSync(path.join(__dirname,'..',file),'utf8'),context);
const data=JSON.parse(JSON.stringify(context.window.CAMPAIGN)),model=createCampaignModel(data);
test('all people and places have independent public player/storyteller authoring fields',()=>{
 assert.deepEqual(validateCampaign(data),[]);
 for(const record of data.records.filter(x=>['person','place'].includes(x.recordType))){
  for(const field of ['notes.player','notes.storyteller']){
   const items=model.itemsFor(record.id).filter(x=>x.fieldKey===field);assert.equal(items.length,1);assert.equal(items[0].body,'');
  }
 }
 const fixture=structuredClone(data),id='person:alan-sovereign';
 fixture.items.find(x=>x.recordId===id&&x.fieldKey==='notes.player').body='A player observation';
 fixture.items.find(x=>x.recordId===id&&x.fieldKey==='notes.storyteller').body='A separate storyteller observation';
 const edited=createCampaignModel(fixture);assert(edited.searchText('people',edited.byId(id)).includes('separate storyteller observation'));
});
test('fixed imported transcripts are searchable and linked separately from changing structured records',()=>{
 assert.equal(model.collections.notes.length,3);
 const alan=model.by('notes','alan-sovereign'),text=model.itemsFor(alan.recordId).find(x=>x.fieldKey==='source.text').body;
 assert(text.includes('Plots and Schemes'));assert(text.includes('Finance: 5 (Stock Market)'));
 assert(model.related('notes',alan).people.some(x=>x.recordId==='person:alan-sovereign'));
 assert(model.related('people',model.by('people','alan-sovereign')).notes.some(x=>x.recordId===alan.recordId));
 assert(model.searchText('notes',model.by('notes','watchtower')).includes('wayne merrick'));
 data.items.find(x=>x.recordId==='person:alan-sovereign'&&x.fieldKey==='person.humanity').value=9;
 assert.equal(model.itemsFor(alan.recordId).find(x=>x.fieldKey==='source.text').body,text);
 assert(data.sources.find(x=>x.id==='source:alan-public-note').noteRecordId===alan.recordId);
});
