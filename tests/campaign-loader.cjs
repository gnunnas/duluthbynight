const {test}=require('node:test'),assert=require('node:assert/strict');
require('../supabase-data.js');const {validateCampaign}=require('../campaign-model.js');
const {createCampaignLoader}=require('../campaign-loader.js'),{exportDraft}=require('../scripts/export-supabase-draft.cjs'),{pageBundle}=require('./helpers/page-bundles.cjs');
const clone=x=>JSON.parse(JSON.stringify(x));
function fixture(){const rows=exportDraft().tables,calls=[];let hold=null;const loader=createCampaignLoader(async(name,p)=>{calls.push(p);if(hold)await hold(p);return clone(pageBundle(rows,p.p_scope,p.p_record));},'duluth-by-night');return {rows,calls,loader,setHold:fn=>hold=fn};}
test('catalog validates without archive text; details deduplicate, cache and reload current page',async()=>{
 const {loader,calls}=fixture();const catalog=await loader.catalog();assert.deepEqual(validateCampaign(catalog),[]);assert(catalog.reviewIssues.some(issue=>issue.id==='review:rack-parent'));assert(!catalog.items.some(i=>i.recordId==='note:alan-sovereign'));
 await Promise.all([loader.ensure('people','alan-sovereign'),loader.record('person:alan-sovereign')]);assert.equal(calls.filter(p=>p.p_record==='person:alan-sovereign').length,1);assert.deepEqual(validateCampaign(loader.project()),[]);
 await loader.ensure('people','alan-sovereign');assert.equal(calls.length,2);
 await loader.ensure('powers','auspex-heightened-senses');assert.deepEqual(validateCampaign(loader.project()),[]);
 await loader.reload();assert.equal(calls.at(-1).p_record,'power:auspex:heightened-senses');assert(!loader.rows.content_items.some(i=>i.record_id==='person:alan-sovereign'&&i.field_key==='notes.storyteller'));
 await loader.ensure('notes','alan-sovereign');assert(loader.rows.content_items.some(i=>i.record_id==='note:alan-sovereign'));
});
test('logout invalidates pending requests and clears account cache',async()=>{
 const {loader,setHold}=fixture();await loader.catalog();let release;setHold(()=>new Promise(r=>release=r));const pending=loader.record('person:alan-sovereign');loader.clear();release();await assert.rejects(pending,/session changed/);assert.deepEqual(loader.rows,{});
});
test('editor is explicit, shared by concurrent opens, and invalidates older detail requests',async()=>{
 const {loader,calls,setHold}=fixture();await loader.catalog();let release;setHold(p=>p.p_scope==='detail'?new Promise(r=>release=r):Promise.resolve());
 const pending=loader.record('person:alan-sovereign'),rejected=assert.rejects(pending,/session changed/);
 await Promise.all([loader.ensure('storyteller'),loader.ensure('edit','person:alan-sovereign')]);assert.equal(calls.filter(p=>p.p_scope==='editor').length,1);release();await rejected;
 const count=calls.length;await loader.record('person:alan-sovereign');assert.equal(calls.length,count);assert.deepEqual(validateCampaign(loader.project()),[]);
});
test('a failed detail retries and removed access refreshes the catalog',async()=>{
 const {loader,rows,setHold,calls}=fixture();await loader.catalog();setHold(()=>{throw Error('Offline');});await assert.rejects(loader.record('person:alan-sovereign'),/Offline/);setHold(null);await loader.record('person:alan-sovereign');
 await loader.ensure('home');await loader.catalog();rows.records=rows.records.filter(r=>r.id!=='person:alan-sovereign');await loader.record('person:alan-sovereign');assert.equal(calls.at(-1).p_scope,'catalog');assert(!loader.rows.records.some(r=>r.id==='person:alan-sovereign'));
});
