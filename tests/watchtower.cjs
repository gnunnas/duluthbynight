const {test}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs'),vm=require('node:vm'),path=require('node:path');
const {createCampaignModel,validateCampaign}=require('../campaign-model.js');
const context={window:{}};
for(const file of ['data.js','campaign-additions.js','discipline-data.js','watchtower-data.js'])vm.runInNewContext(fs.readFileSync(path.join(__dirname,'..',file),'utf8'),context);
const data=JSON.parse(JSON.stringify(context.window.CAMPAIGN)),model=createCampaignModel(data),id='place:watchtower';
test('Watchtower additions validate and preserve Twig geography and uncertain domain claim',()=>{
 assert.deepEqual(validateCampaign(data),[]);assert.equal(model.byId(id).parent,'twig');
 assert.equal(model.itemsFor(id).find(x=>x.fieldKey==='place.havenFor').value,'Player coterie');
 assert.equal(data.domainClaims.find(x=>x.placeId===id).claimantRecordId,null);
});
test('floor directory and personnel keep nested notes under the existing location',()=>{
 const sections=model.sectionsFor(id),items=model.itemsFor(id);
 const floors=sections.find(x=>x.templateKey==='floor-directory');assert.equal(floors.displayStyle,'directory');
 assert.equal(items.filter(x=>x.sectionId===floors.id&&!x.parentItemId).length,13);
 const privateFloors=sections.find(x=>x.templateKey==='private-floors');assert.equal(items.filter(x=>x.sectionId===privateFloors.id&&!x.parentItemId).length,3);
 const roster=sections.find(x=>x.templateKey==='security-personnel');assert.equal(items.filter(x=>x.sectionId===roster.id&&!x.parentItemId).length,10);
 assert(items.some(x=>x.body?.includes('$960,000')));
 assert(model.searchText('places',model.byId(id)).includes('caliburn trust'));
 assert(model.searchText('places',model.byId(id)).includes('wayne merrick'));
 assert(items.some(x=>x.links?.some(link=>link.recordId==='place:bliss')));
});
