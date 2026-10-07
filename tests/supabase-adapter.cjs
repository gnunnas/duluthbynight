const test=require('node:test'),assert=require('node:assert/strict');
const {exportDraft}=require('../scripts/export-supabase-draft.cjs');
const {adaptSupabase}=require('../supabase-data.js');
const {createCampaignModel,validateCampaign}=require('../campaign-model.js');
test('full database import projects into existing views without static data',()=>{
 const result=exportDraft(),data=adaptSupabase(result.tables,result.campaignId);
 assert.deepEqual(validateCampaign(data),[]);
 const model=createCampaignModel(data),alan=model.byId('person:alan-sovereign');
 assert.equal(alan.name,'Alan Sovereign');assert(alan.portrait.src.includes('alan sovereign'));
 assert.equal(model.byId('place:watchtower').parent,'twig');
 assert.equal(model.byId('power:auspex:heightened-senses').level,1);
 assert.equal(data.items.find(x=>x.fieldKey==='mechanics.discipline'&&x.value.abilities?.length).value.abilities[0].recordId,'power:auspex:heightened-senses');
});
test('no revealed records is a valid empty campaign',()=>{
 const data=adaptSupabase({},'duluth-by-night');assert.deepEqual(validateCampaign(data),[]);
 assert.equal(createCampaignModel(data).collections.people.length,0);
});
test('hidden alias targets are removed from player projections',()=>{
 const data=adaptSupabase({route_aliases:[{old_route:'people/old',target_route:'people/secret'}]},'duluth-by-night');
 assert.deepEqual(data.routeAliases,{});
});
