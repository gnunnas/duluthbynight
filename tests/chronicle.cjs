const {test}=require('node:test'),assert=require('node:assert/strict');
const {adaptSupabase}=require('../supabase-data.js'),{createCampaignModel}=require('../campaign-model.js'),{pageBundle}=require('./helpers/page-bundles.cjs');
const {fixture}=require('./helpers/chronicle-fixture.cjs');
test('catalog carries completion and both dates; latest dated session sorts first without inventing dates',()=>{
 const model=createCampaignModel(adaptSupabase(pageBundle(fixture(),'catalog'),'duluth-by-night'));
 assert.equal(model.by('threads','kyra-hunt').status,'completed');assert.equal(model.by('threads','dark-mother').status,'active');
 assert.equal(model.collections.chronicle[0].id,'history-fixture');assert.equal(model.collections.chronicle[0].date,'April 10, 2027');assert.equal(model.collections.chronicle[0].inWorldDate,'June 1998');
 assert.equal(model.by('chronicle','2026-09-11').date,'September 11');assert.equal(model.by('chronicle','2026-09-11').inWorldDate,undefined);
});
