const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const crypto = require('node:crypto');
const root = path.join(__dirname, '..');
const sourcePath = path.join(root, 'migration/phase-1-source.js');
const sourceBytes = fs.readFileSync(sourcePath);
const context = {window:{}};
vm.runInNewContext(sourceBytes.toString(), context);
const old = JSON.parse(JSON.stringify(context.window.CAMPAIGN));
const typeMap = {people:'person',places:'place',clans:'clan',groups:'organization',factions:'organization',threads:'thread',sessions:'session'};
const routeMap = {people:'people',places:'places',clans:'clans',groups:'organizations',factions:'organizations',threads:'threads',sessions:'chronicle'};
const data = {schemaVersion:2,campaignId:'duluth-by-night',publication:'public-static',records:[],names:[],sections:[],items:[],relationshipTypes:[],relationships:[],domainClaims:[],membershipImplications:[],attachments:[],sources:[{id:'source:phase-1-baseline',sourceKind:'note',label:'Existing public dataset'},{id:'source:confirmed-names',sourceKind:'user_confirmation',label:'Confirmed contextual place names'},{id:'source:confirmed-inheritance',sourceKind:'user_confirmation',label:'Confirmed Night Forum affiliation rule'}],routeAliases:{},viewConfig:{},reviewIssues:[]};
const baselineSource = [{sourceId:'source:phase-1-baseline'}];
const idMap = {}, routeAudit = {}, semanticChanges = [];
const uid = (collection, id) => `${typeMap[collection]}:${id}`;
function section(recordId,key,heading) {
 const id=`section:${recordId}:${key}`;
 if(!data.sections.some(x=>x.id===id))data.sections.push({id,recordId,templateKey:key,heading,sortOrder:data.sections.filter(x=>x.recordId===recordId).length});
 return id;
}
function item(recordId,key,value,options={}) {
 const sectionKey=options.sectionKey || (key==='overview'?'overview':'facts');
 const sectionId=section(recordId,sectionKey,sectionKey==='overview'?'Overview':sectionKey==='facts'?'Recorded facts':'Connections');
 const row={id:`item:${recordId}:${key}`,recordId,sectionId,itemKind:key==='overview'?'note':'fact',fieldKey:key,knowledgeState:value===null?'unknown':'recorded',sourceRefs:baselineSource,sortOrder:data.items.filter(x=>x.sectionId===sectionId).length,...options};
 delete row.sectionKey;
 if(key==='overview')row.body=value;else {row.value=value;row.valueType=options.valueType || (typeof value==='string'?'text':'unknown');}
 data.items.push(row);return row;
}
function rel(type,from,to,key,extra={}) {
 const row={id:`relationship:${key}`,relationshipType:type,fromRecordId:from,toRecordId:to,knowledgeState:'recorded',sourceRefs:baselineSource,...extra};
 data.relationships.push(row);return row;
}
function relationshipType(id,fromTypes,toTypes,forwardLabel,reverseLabel,symmetric=false) {
 data.relationshipTypes.push({id,fromTypes:[...new Set(fromTypes)],toTypes:[...new Set(toTypes)],forwardLabel,reverseLabel,symmetric});
}
relationshipType('associated_with',['person'],['person'],'Associated with','Associated with',true);
relationshipType('sire_of',['person'],['person'],'Sire of','Childe of');
relationshipType('employs',['person','organization'],['person'],'Employs','Employed by');
relationshipType('clan_member_of',['person'],['clan'],'Clan','Recorded clan members');
relationshipType('member_of',['person'],['organization'],'Member of','Members');
relationshipType('associate_of',['person'],['organization'],'Associated with','Associates');
relationshipType('affiliated_with',['person','organization'],['organization'],'Affiliated with','Affiliates');
relationshipType('associated_with_place',['person'],['place'],'Associated place','Associated people');
relationshipType('contained_in',['place'],['place'],'Within','Contains');
relationshipType('subgroup_of',['organization'],['organization'],'Subgroup of','Subgroups');
relationshipType('related_to',Object.values(typeMap),Object.values(typeMap),'Related','Related',true);
relationshipType('involves',['thread'],['person','place','organization','clan','session'],'Related records','Related threads');
relationshipType('references',['session'],['person','place','thread','organization','clan'],'Referenced records','Session references');
for(const [collection,type] of Object.entries(typeMap)) {
 for(const original of old[collection] || []) {
  const id=uid(collection,original.id);
  if(data.records.some(x=>x.id===id))throw new Error('Duplicate identity: '+id);
  data.records.push({id,recordType:type,routeKey:original.id,displayName:original.name || original.title});
  idMap[`${collection}/${original.id}`]=id;
  const canonical=`${routeMap[collection]}/${original.id}`;
  routeAudit[`${collection==='sessions'?'chronicle':collection}/${original.id}`]=canonical;
  if(collection==='groups'||collection==='factions')data.routeAliases[`${collection}/${original.id}`]=canonical;
  data.names.push({id:`name:${id}:primary`,recordId:id,text:original.name||original.title,nameKind:'common'});
  if(original.summary)item(id,'overview',original.summary);
  if(original.type)item(id,'person.nature',original.type);
  if(original.kind !== undefined)item(id,`${type}.kind`,original.kind);
  if(collection==='groups'||collection==='factions')item(id,'organization.browseCategory',collection==='groups'?'group':'political');
  if(original.affiliationStatus)item(id,'person.affiliationStatus',original.affiliationStatus);
  if(original.date)item(id,'session.date',{text:original.date,precision:'unknown',calendar:'real_world'},{valueType:'date_expression'});
 }
}
for(const person of old.people) {
 const from=uid('people',person.id);
 if(person.clan)rel('clan_member_of',from,uid('clans',person.clan),`${from}:clan`);
 for(const membership of person.memberships || []) {
  const kind=['nora','georgia'].includes(person.id)?'associate_of':'member_of';
  const row=rel(kind,from,uid('groups',membership.group),`${from}:group:${membership.group}`);
  item(from,`${row.id}:role`,membership.role??null,{sectionKey:'connections',subjectRef:{kind:'relationship',id:row.id},fieldKey:'relationship.role'});
  if(kind==='associate_of')semanticChanges.push({recordId:from,change:'Legacy membership clarified as association using the existing summary; no formal membership inferred.'});
 }
 for(const affiliation of person.affiliations || []) {
  const row=rel('affiliated_with',from,uid('factions',affiliation.faction),`${from}:affiliation:${affiliation.faction}`);
  item(from,`${row.id}:role`,affiliation.role??null,{sectionKey:'connections',subjectRef:{kind:'relationship',id:row.id},fieldKey:'relationship.role'});
 }
 for(const place of person.places || [])rel('associated_with_place',from,uid('places',place),`${from}:place:${place}`);
}
for(const place of old.places) {
 const id=uid('places',place.id);
 if(place.parent)rel('contained_in',id,uid('places',place.parent),`${id}:parent`,place.id==='rack'?{knowledgeState:'unverified'}:{});
 if(place.domain)data.domainClaims.push({id:`claim:${id}:legacy`,placeId:id,claimantRecordId:null,status:'unspecified',sourceRefs:baselineSource});
 const children=old.places.filter(x=>x.parent===place.id).map(x=>x.id).sort();
 if(place.children && JSON.stringify([...place.children].sort())!==JSON.stringify(children))throw new Error('Child list disagrees with parents: '+id);
}
for(const collection of ['groups','factions'])for(const original of old[collection]) {
 const id=uid(collection,original.id);
 if(original.parent)rel('subgroup_of',id,uid(collection,original.parent),`${id}:parent`);
 for(const place of original.places || [])rel('related_to',id,uid('places',place),`${id}:place:${place}`);
}
for(const relationship of old.relationships) {
 const row=rel('associated_with',uid('people',relationship.from),uid('people',relationship.to),relationship.id);
 item(uid('people',relationship.from),`${row.id}:details`,relationship.label,{sectionKey:'connections',subjectRef:{kind:'relationship',id:row.id},fieldKey:'relationship.details'});
 idMap[`relationships/${relationship.id}`]=row.id;
}
for(const collection of ['threads','sessions'])for(const record of old[collection])for(const target of ['people','places','threads']) {
 for(const id of record[target] || [])rel(collection==='threads'?'involves':'references',uid(collection,record.id),uid(target,id),`${collection}:${record.id}:${target}:${id}`);
}
const rack=data.records.find(x=>x.id==='place:rack');
rack.displayName='Canal Park · The Rack';
const rackName=data.names.find(x=>x.recordId===rack.id);
rackName.text='Canal Park';rackName.context='Mortal / common';rackName.sourceRefs=[{sourceId:'source:confirmed-names'}];
data.names.push({id:'name:place:rack:kindred',recordId:rack.id,text:'The Rack',nameKind:'alias',context:'Kindred',sourceRefs:[{sourceId:'source:confirmed-names'}]});
const rackOverview=data.items.find(x=>x.recordId===rack.id&&x.fieldKey==='overview');
const oldRackSummary=rackOverview.body;
rackOverview.body='Canal Park is known to Kindred as The Rack.';rackOverview.sourceRefs=[{sourceId:'source:confirmed-names'}];
semanticChanges.push({recordId:rack.id,change:'Unified confirmed names; removed the network-only overview from current assertions.',originalOverview:oldRackSummary,replacementOverview:rackOverview.body});
data.reviewIssues.push({id:'review:rack-parent',recordId:rack.id,displayMessage:'Containing district is unconfirmed.',message:'Primary geographic parent is unconfirmed. Downtown is retained as a legacy value, not a new assertion.'},{id:'review:eldes-parent',recordId:'place:eldes-corner',message:'Whether West Duluth is an intermediate geographic parent remains unconfirmed; retain the established Duluth parent.'});
const anarchs={id:'organization:anarchs',recordType:'organization',routeKey:'anarchs',displayName:'Anarchs'};
data.records.push(anarchs);data.names.push({id:'name:organization:anarchs:primary',recordId:anarchs.id,text:'Anarchs',nameKind:'common',sourceRefs:[{sourceId:'source:confirmed-inheritance'}]});
item(anarchs.id,'organization.browseCategory','political',{sourceRefs:[{sourceId:'source:confirmed-inheritance'}]});
rel('subgroup_of','organization:night-forum',anarchs.id,'night-forum:anarchs',{sourceRefs:[{sourceId:'source:confirmed-inheritance'}]});
data.membershipImplications.push({id:'implication:night-forum:anarchs',sourceOrganizationId:'organization:night-forum',targetOrganizationId:anarchs.id,eligibleConnectionTypes:['member_of'],enabled:true,sourceRefs:[{sourceId:'source:confirmed-inheritance'}]});
semanticChanges.push({recordId:'organization:night-forum',change:'Added the confirmed one-way membership implication to Anarchs; Nora remains an associate, so no membership is inferred for her.'});
for(const [legacy,target] of Object.entries(old.legacyRoutes))data.routeAliases[legacy]=data.routeAliases[target] || target;
data.routeAliases.groups='organizations?category=group';data.routeAliases.factions='organizations?category=political';
data.viewConfig.tonight={...old.tonight,place:uid('places',old.tonight.place),faces:old.tonight.faces.map(id=>uid('people',id))};
const report={sourceSha256:crypto.createHash('sha256').update(sourceBytes).digest('hex'),sourceCounts:Object.fromEntries(Object.keys(typeMap).map(key=>[key,old[key]?.length||0])),targetCounts:Object.fromEntries(['records','names','sections','items','relationships','domainClaims','membershipImplications'].map(key=>[key,data[key].length])),idMap,routes:routeAudit,semanticChanges,reviewIssues:data.reviewIssues};
const output='// Public static campaign dataset. Generated by scripts/migrate-phase-1.cjs.\nwindow.CAMPAIGN = '+JSON.stringify(data,null,2)+';\n';
const reportOutput=JSON.stringify(report,null,2)+'\n';
if(!process.argv.includes('--write')) {
 if(fs.readFileSync(path.join(root,'data.js'),'utf8')!==output || fs.readFileSync(path.join(root,'migration/phase-1-report.json'),'utf8')!==reportOutput)throw new Error('Migration outputs differ from the retained source.');
 console.log('Migration output is reproducible and matches the retained source.');
} else {
 fs.writeFileSync(path.join(root,'data.js'),output);fs.writeFileSync(path.join(root,'migration/phase-1-report.json'),reportOutput);
 console.log(`Migrated ${data.records.length} records and ${data.relationships.length} relationships. Source snapshot retained.`);
}
