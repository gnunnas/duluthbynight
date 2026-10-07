// Convert only the rows Supabase returned under the signed-in user's RLS policies.
(function(root){
const collections={records:'records',record_names:'names',sections:'sections',content_items:'items',relationship_types:'relationshipTypes',relationships:'relationships',domain_claims:'domainClaims',membership_implications:'membershipImplications',attachments:'attachments',sources:'sources'};
const camel=key=>key.replace(/_([a-z])/g,(_,c)=>c.toUpperCase());
function adaptSupabase(rows,campaignId){
 const data={schemaVersion:2,campaignId,publication:'supabase-rls',routeAliases:{},reviewIssues:[],viewConfig:{}};
 const convert=row=>Object.fromEntries(Object.entries(row).map(([key,value])=>[camel(key),value]));
 for(const [table,key]of Object.entries(collections))data[key]=(rows[table]||[]).map(convert);
 for(const type of data.relationshipTypes)type.symmetric=type.isSymmetric;
 const items=new Map(data.items.map(x=>[x.id,x]));
 for(const item of items.values()){
  if(item.referenceRecordId)item.value={...(item.value||{}),referenceRecordId:item.referenceRecordId};
  for(const kind of ['relationship','claim','name'])if(item['subject'+kind[0].toUpperCase()+kind.slice(1)+'Id'])item.subjectRef={kind,id:item['subject'+kind[0].toUpperCase()+kind.slice(1)+'Id']};
 }
 for(const ref of rows.item_references||[]){const item=items.get(ref.item_id);if(item)(item.links||=[]).push({recordId:ref.target_record_id,text:ref.label});}
 for(const selection of rows.selected_powers||[]){const item=items.get(selection.item_id);if(item){item.value||={};(item.value.abilities||=[]).push({recordId:selection.power_record_id,name:selection.label,notes:selection.notes});}}
 if((rows.power_definitions||[]).length&&!data.relationshipTypes.some(x=>x.id==='power_of'))data.relationshipTypes.push({id:'power_of',fromTypes:['power'],toTypes:['discipline'],forwardLabel:'Discipline',reverseLabel:'Abilities',symmetric:false});
 for(const power of rows.power_definitions||[]){
  const sectionId='db:power-level:'+power.power_record_id;
  data.sections.push({id:sectionId,recordId:power.power_record_id,templateKey:'facts',heading:'Facts'});
  data.items.push({id:sectionId,recordId:power.power_record_id,sectionId,itemKind:'fact',fieldKey:'power.level',value:power.level});
  data.relationships.push({id:'db:power-parent:'+power.power_record_id,relationshipType:'power_of',fromRecordId:power.power_record_id,toRecordId:power.discipline_record_id});
 }
 for(const attachment of data.attachments){attachment.src=attachment.legacyPath;attachment.alt=attachment.altText;}
 for(const [table,key]of Object.entries(collections)){
  const owners=new Map(data[key].map(x=>[x.id,x]));
  for(const ref of rows[table+'_sources']||[]){const owner=owners.get(ref.owner_id);if(owner)(owner.sourceRefs||=[]).push({sourceId:ref.source_id,locator:ref.locator});}
 }
 data.personStatus=(rows.person_status||[]).map(convert);
 const recordIds=new Set(data.records.map(x=>x.id));
 const routeRecords=new Set(data.records.map(x=>({person:'people',place:'places',clan:'clans',organization:'organizations',thread:'threads',session:'chronicle',scheme:'schemes',event:'events',discipline:'disciplines',power:'powers',note:'notes'}[x.recordType])+'/'+x.routeKey));
 for(const alias of rows.route_aliases||[]){if(!alias.target_route.split('?')[0].includes('/')||routeRecords.has(alias.target_route.split('?')[0]))data.routeAliases[alias.old_route]=alias.target_route;}
 data.reviewIssues=(rows.review_issues||[]).filter(x=>recordIds.has(x.record_id)).map(x=>({...x.details,id:x.id,recordId:x.record_id}));
 return data;
}
root.adaptSupabase=adaptSupabase;
if(typeof module!=='undefined')module.exports={adaptSupabase};
})(globalThis);
