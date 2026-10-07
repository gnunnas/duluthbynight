// Read-only preparation. Writes a local review bundle, never contacts Supabase.
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const {validateCampaign}=require('../campaign-model.js');
function exportDraft(){
 const context={window:{}};
 for(const file of ['data.js','campaign-additions.js','discipline-data.js','watchtower-data.js','source-notes.js'])vm.runInNewContext(fs.readFileSync(path.join(__dirname,'..',file),'utf8'),context);
 const data=JSON.parse(JSON.stringify(context.window.CAMPAIGN));
 const errors=validateCampaign(data);if(errors.length)throw Error(errors.join('\n'));
 const originalSnapshot=structuredClone(data);
 const c=data.campaignId,tables={};
 const base=x=>({campaign_id:c,id:x.id,audience:'storyteller',origin:'import'});
 const snake=s=>s.replace(/[A-Z]/g,ch=>'_'+ch.toLowerCase());
 const fields=(x,keys)=>Object.fromEntries(keys.filter(k=>x[k]!==undefined).map(k=>[snake(k),x[k]]));
 tables.records=data.records.map(x=>({...base(x),...fields(x,['recordType','routeKey','displayName'])}));
 tables.record_names=data.names.map(x=>({...base(x),...fields(x,['recordId','text','nameKind','context','validFrom','validUntil'])}));
 tables.sections=data.sections.map(x=>({...base(x),...fields(x,['recordId','templateKey','heading','displayStyle','sortOrder']),...(['player-notes'].includes(x.templateKey)?{audience:'players'}:{})}));
 tables.relationship_types=data.relationshipTypes.map(x=>({campaign_id:c,id:x.id,...fields(x,['fromTypes','toTypes','forwardLabel','reverseLabel']),is_symmetric:x.symmetric}));
 tables.relationships=data.relationships.filter(x=>x.relationshipType!=='power_of').map(x=>({...base(x),...fields(x,['relationshipType','fromRecordId','toRecordId','contextRecordId','perspectiveRecordId','knowledgeState','validFrom','validUntil'])}));
 tables.domain_claims=data.domainClaims.map(x=>({...base(x),...fields(x,['placeId','claimantRecordId','status','validFrom','validUntil'])}));
 const levels=data.items.filter(x=>x.fieldKey==='power.level');
 const content=data.items.filter(x=>x.fieldKey!=='power.level');
 tables.content_items=content.map(x=>{
  const row={...base(x),...fields(x,['recordId','sectionId','parentItemId','itemKind','fieldKey','title','body','value','valueType','qualifier','knowledgeState','sortOrder','titleRecordId','perspectiveRecordId','validFrom','validUntil'])};
  if(x.fieldKey==='notes.player')row.audience='players';
  if(x.value?.referenceRecordId){row.reference_record_id=x.value.referenceRecordId;delete row.value.referenceRecordId;}
  if(row.value&&typeof row.value==='object')delete row.value.abilities;
  if(x.subjectRef)row['subject_'+({relationship:'relationship',claim:'claim',name:'name'})[x.subjectRef.kind]+'_id']=x.subjectRef.id;
  return row;
 });
 tables.item_references=content.flatMap(x=>(x.links||[]).map((ref,index)=>({...base({id:x.id+':inline:'+index}),item_id:x.id,target_record_id:ref.recordId,label:ref.text})));
 tables.membership_implications=data.membershipImplications.map(x=>({...base(x),...fields(x,['sourceOrganizationId','targetOrganizationId','eligibleConnectionTypes','enabled'])}));
 tables.power_definitions=data.records.filter(x=>x.recordType==='power').map(x=>({campaign_id:c,power_record_id:x.id,discipline_record_id:data.relationships.find(r=>r.fromRecordId===x.id&&r.relationshipType==='power_of').toRecordId,level:levels.find(i=>i.recordId===x.id).value}));
 // Use the unmodified original data for selected powers; content row mapping removes JSON refs from its copy.
 const raw=originalSnapshot;
 tables.selected_powers=raw.items.flatMap(x=>(x.value?.abilities||[]).map((ability,index)=>{
  if(!ability.recordId)throw Error('Selected ability needs a real reference before migration: '+x.id);
  return {...base({id:x.id+':power:'+index}),item_id:x.id,discipline_record_id:x.value.referenceRecordId,power_record_id:ability.recordId,...(ability.name?{label:ability.name}:{}),...(ability.notes?{notes:ability.notes}:{})};
 }));
 tables.person_status=data.records.filter(x=>x.recordType==='person').map(x=>({...base({id:'status:'+x.id}),person_record_id:x.id,permanently_dead:'unknown'}));
 tables.sources=data.sources.map(x=>({...base(x),...fields(x,['sourceKind','label','editorialDate','noteRecordId'])}));
 tables.attachments=data.attachments.map(x=>({...base(x),...fields(x,['recordId','itemId','attachmentKind','caption','sortOrder']),legacy_path:x.src||null,alt_text:x.alt||null}));
 tables.route_aliases=Object.entries(data.routeAliases).map(([old_route,target_route])=>({campaign_id:c,old_route,target_route}));
 tables.review_issues=data.reviewIssues.map(x=>({campaign_id:c,id:x.id,record_id:x.recordId,details:x}));
 for(const [key,rows] of Object.entries({record_names:data.names,content_items:content,relationships:data.relationships.filter(x=>x.relationshipType!=='power_of'),domain_claims:data.domainClaims,membership_implications:data.membershipImplications,attachments:data.attachments})){
  tables[key+'_sources']=rows.flatMap(x=>(x.sourceRefs||[]).map(ref=>({campaign_id:c,owner_id:x.id,source_id:ref.sourceId,...(ref.locator?{locator:ref.locator}:{})})));
 }
 tables.power_definitions_sources=tables.power_definitions.flatMap(power=>{
  const refs=[...raw.items.filter(x=>x.recordId===power.power_record_id&&x.fieldKey==='power.level'),...raw.relationships.filter(x=>x.fromRecordId===power.power_record_id&&x.relationshipType==='power_of')].flatMap(x=>x.sourceRefs||[]);
  return [...new Map(refs.map(ref=>[ref.sourceId,{campaign_id:c,owner_id:power.power_record_id,source_id:ref.sourceId,...(ref.locator?{locator:ref.locator}:{})}])).values()];
 });
 return {draft:true,campaignId:c,defaultAudience:'storyteller',tables,originalSnapshot:raw,report:{counts:Object.fromEntries(Object.entries(tables).map(([k,v])=>[k,v.length])),transforms:['power_of relationships and power.level items become power_definitions','Mechanic references, selected abilities, and inline links become foreign-key rows','Player notes are campaign-player shared; Storyteller notes remain Storyteller-only','Death values are initialized unknown, never inferred','Homepage configuration remains in originalSnapshot pending an authorized database adapter'],warnings:['No database connection or write performed','All other imported rows default to Storyteller-only pending audience review','Old public files cannot be made private by changing database permissions','Original screenshot archives are imported-text snapshots, not original source files']}};
}
if(require.main===module){const i=process.argv.indexOf('--out');if(i<0||!process.argv[i+1])throw Error('Usage: node scripts/export-supabase-draft.cjs --out /tmp/campaign-draft.json');const result=exportDraft();fs.writeFileSync(process.argv[i+1],JSON.stringify(result,null,2)+'\n');console.log(JSON.stringify(result.report,null,2));}
module.exports={exportDraft};
