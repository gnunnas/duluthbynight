// Normalized public-data adapter. No authentication or private-data filtering is implied.
(function (root) {
  const routes = {person:'people',place:'places',clan:'clans',organization:'organizations',thread:'threads',session:'chronicle',scheme:'schemes',event:'events',discipline:'disciplines',power:'powers'};
  function validateCampaign(data) {
    const errors = [];
    const arrayFields=['records','names','sections','items','relationshipTypes','relationships','domainClaims','membershipImplications','attachments','sources'];
    for (const key of arrayFields) if (!Array.isArray(data[key])) errors.push('Missing collection: '+key);
    if (errors.length) return errors;
    if (!data.campaignId) errors.push('Missing campaign boundary');
    const fail = message => errors.push(message);
    if (data.schemaVersion !== 2) fail('Unsupported schemaVersion');
    if (data.publication !== 'public-static') fail('This adapter expects an approved public static dataset');
    const map = (rows, label) => {
      const result = new Map();
      for (const row of rows || []) { if (!row.id || result.has(row.id)) fail(`Duplicate/missing ${label} ID: ${row.id}`); result.set(row.id,row); }
      return result;
    };
    const records = map(data.records,'record'), sections=map(data.sections,'section'), items=map(data.items,'item');
    const types=map(data.relationshipTypes,'relationship type'), relationships=map(data.relationships,'relationship');
    const claims=map(data.domainClaims,'claim'), names=map(data.names,'name'), sources=map(data.sources,'source');
    for (const rows of arrayFields.map(key=>data[key])) for (const row of rows) if (row.campaignId && row.campaignId!==data.campaignId) fail('Cross-campaign row: '+row.id);
    map(data.membershipImplications,'implication');map(data.attachments,'attachment');
    const keys = new Set();
    for (const record of records.values()) {
      if (record.campaignId && record.campaignId !== data.campaignId) fail('Cross-campaign record: '+record.id);
      if (!routes[record.recordType] || !record.displayName || !record.routeKey) fail('Invalid record shell: '+record.id);
      const key=`${record.recordType}/${record.routeKey}`;
      if(keys.has(key))fail('Duplicate route: '+key);keys.add(key);
    }
    for (const name of names.values()) if(!records.has(name.recordId)||!name.text)fail('Invalid name: '+name.id);
    for (const section of sections.values()) if(!records.has(section.recordId))fail('Missing section owner: '+section.id);
    const cycles = (edges,label) => {
      const adjacency=new Map();
      for(const [from,to] of edges){if(!adjacency.has(from))adjacency.set(from,[]);adjacency.get(from).push(to);}
      const active=new Set(),done=new Set();
      function visit(id){if(active.has(id)){fail(label+' cycle: '+id);return;}if(done.has(id))return;active.add(id);for(const to of adjacency.get(id)||[])visit(to);active.delete(id);done.add(id);}
      for(const id of adjacency.keys())visit(id);
    };
    const duplicates=new Set(), parents=new Set();
    for(const relation of relationships.values()) {
      const type=types.get(relation.relationshipType),from=records.get(relation.fromRecordId),to=records.get(relation.toRecordId);
      if(!type||!from||!to){fail('Missing relationship endpoint/type: '+relation.id);continue;}
      if(!type.fromTypes?.includes(from.recordType)||!type.toTypes?.includes(to.recordType))fail('Incompatible endpoint type: '+relation.id);
      if(from.id===to.id)fail('Self relationship: '+relation.id);
      const pair=type.symmetric?[from.id,to.id].sort():[from.id,to.id];
      const signature=JSON.stringify([type.id,pair,relation.contextRecordId||null,relation.validFrom||null,relation.validUntil||null]);
      if(duplicates.has(signature))fail('Duplicate relationship: '+relation.id);duplicates.add(signature);
      if(relation.relationshipType==='contained_in'){if(parents.has(from.id))fail('Multiple primary parents: '+from.id);parents.add(from.id);}
    }
    for(const kind of ['contained_in','subgroup_of'])cycles([...relationships.values()].filter(x=>x.relationshipType===kind).map(x=>[x.fromRecordId,x.toRecordId]),kind);
    for(const entry of items.values()) {
      if(!records.has(entry.recordId)||sections.get(entry.sectionId)?.recordId!==entry.recordId)fail('Invalid item owner/section: '+entry.id);
      if(entry.titleRecordId && !records.has(entry.titleRecordId)) fail('Missing title reference: '+entry.id);
      for(const link of entry.links||[])if(!records.has(link.recordId)||!link.text)fail('Invalid inline link: '+entry.id);
      if(entry.itemKind==='mechanic' && (!Number.isFinite(entry.value?.rating)||entry.value.rating<0))fail('Invalid mechanic rating: '+entry.id);
      if(entry.value?.referenceRecordId && !records.has(entry.value.referenceRecordId))fail('Missing mechanic reference: '+entry.id);
      for(const ability of entry.value?.abilities||[])if(ability.recordId&&!records.has(ability.recordId))fail('Missing ability reference: '+entry.id);
      if(entry.parentItemId && items.get(entry.parentItemId)?.recordId!==entry.recordId)fail('Invalid parent item: '+entry.id);
      if(entry.subjectRef){const lookup={relationship:relationships,claim:claims,name:names};if(!lookup[entry.subjectRef.kind]?.has(entry.subjectRef.id))fail('Invalid item subject: '+entry.id);}
    }
    cycles([...items.values()].filter(x=>x.parentItemId).map(x=>[x.id,x.parentItemId]),'item nesting');
    for(const record of records.values())if(record.recordType==='power'){
      const parents=[...relationships.values()].filter(x=>x.fromRecordId===record.id&&x.relationshipType==='power_of');
      if(parents.length!==1)fail('Ability needs exactly one discipline: '+record.id);
      const level=[...items.values()].find(x=>x.recordId===record.id&&x.fieldKey==='power.level')?.value;
      if(!Number.isInteger(level)||level<1||level>5)fail('Invalid ability level: '+record.id);
    }
    for(const entry of items.values())if(entry.fieldKey==='mechanics.discipline'){
      const discipline=entry.value?.referenceRecordId;
      if(discipline&&records.get(discipline)?.recordType!=='discipline')fail('Invalid discipline reference: '+entry.id);
      for(const ability of entry.value?.abilities||[])if(ability.recordId&&records.has(ability.recordId)){
        if(records.get(ability.recordId).recordType!=='power')fail('Invalid ability reference: '+entry.id);
        if(!discipline||![...relationships.values()].some(x=>x.relationshipType==='power_of'&&x.fromRecordId===ability.recordId&&x.toRecordId===discipline))fail('Ability discipline mismatch: '+entry.id);
        const level=[...items.values()].find(x=>x.recordId===ability.recordId&&x.fieldKey==='power.level')?.value;
        if(level>entry.value.rating)fail('Ability exceeds discipline rating: '+entry.id);
      }
    }
    for(const claim of claims.values()) {
      if(records.get(claim.placeId)?.recordType!=='place')fail('Invalid claim place: '+claim.id);
      if(claim.claimantRecordId && !['person','organization'].includes(records.get(claim.claimantRecordId)?.recordType))fail('Invalid claimant: '+claim.id);
    }
    for(const attachment of data.attachments) if(!records.has(attachment.recordId)||(attachment.itemId&&!items.has(attachment.itemId)))fail('Invalid attachment owner: '+attachment.id);
    for(const rule of data.membershipImplications || []) {
      if(records.get(rule.sourceOrganizationId)?.recordType!=='organization'||records.get(rule.targetOrganizationId)?.recordType!=='organization')fail('Invalid implication endpoints: '+rule.id);
      if(!rule.eligibleConnectionTypes?.length || rule.eligibleConnectionTypes.some(x=>!['member_of','associate_of','affiliated_with'].includes(x)))fail('Invalid implication connection types: '+rule.id);
    }
    cycles((data.membershipImplications||[]).filter(x=>x.enabled).map(x=>[x.sourceOrganizationId,x.targetOrganizationId]),'membership implication');
    for(const row of [...names.values(),...items.values(),...relationships.values(),...claims.values(),...(data.membershipImplications||[])])for(const ref of row.sourceRefs||[])if(!sources.has(ref.sourceId))fail('Missing source: '+row.id);
    for(const issue of data.reviewIssues || [])if(!records.has(issue.recordId))fail('Invalid review record: '+issue.id);
    const aliases=data.routeAliases||{};
    for(const start of Object.keys(aliases)){
      const seen=new Set();let target=start;
      while(aliases[target]){if(seen.has(target)){fail('Route alias cycle: '+start);break;}seen.add(target);target=aliases[target];}
      const [path]=target.split('?'),[route,key]=path.split('/');
      if(!['home','search',...Object.values(routes)].includes(route))fail('Unknown alias route: '+target);
      if(key && ![...records.values()].some(x=>routes[x.recordType]===route&&x.routeKey===key))fail('Missing alias record: '+target);
    }
    const tonight=data.viewConfig?.tonight;
    if(tonight){if(records.get(tonight.place)?.recordType!=='place')fail('Invalid homepage place');for(const id of tonight.faces||[])if(records.get(id)?.recordType!=='person')fail('Invalid homepage face');}
    return errors;
  }
  function createCampaignModel(data) {
    const errors=validateCampaign(data);if(errors.length)throw new Error(errors.join('\n'));
    const rawById=new Map(data.records.map(x=>[x.id,x]));
    const relationshipTypes=new Map(data.relationshipTypes.map(x=>[x.id,x]));
    const field=(id,key)=>data.items.find(x=>x.recordId===id&&x.fieldKey===key);
    const value=(id,key)=>field(id,key)?.value;
    const role=relation=>data.items.find(x=>x.subjectRef?.kind==='relationship'&&x.subjectRef.id===relation.id&&x.fieldKey==='relationship.role')?.value??null;
    const direct=id=>data.relationships.filter(x=>x.fromRecordId===id);
    function membershipConnections(personId, options={}) {
      const buckets=new Map();
      const add=(organizationId,type,path,isDirect)=>{
        if(!buckets.has(organizationId))buckets.set(organizationId,{organizationId,connectionTypes:[],direct:false,paths:[]});
        const bucket=buckets.get(organizationId);if(!bucket.connectionTypes.includes(type))bucket.connectionTypes.push(type);bucket.direct ||= isDirect;
        if(!bucket.paths.some(x=>JSON.stringify(x)===JSON.stringify(path)))bucket.paths.push(path);
      };
      const queue=[];
      for(const relation of direct(personId).filter(x=>['member_of','associate_of','affiliated_with'].includes(x.relationshipType))) {
        const path={organizationIds:[relation.toRecordId],relationshipIds:[relation.id],implicationIds:[]};
        add(relation.toRecordId,relation.relationshipType,path,true);
        // Ambiguous or historical timing cannot create an unqualified derived membership.
        const date=options.atDate;
        const start=relation.validFrom?.start,end=relation.validUntil?.end||relation.validUntil?.start;
        const dated=relation.validFrom||relation.validUntil;
        const active=!dated || (date && (!start||date>=start)&&(!end||date<=end)&&(!relation.validFrom||start)&&(!relation.validUntil||end));
        if(relation.knowledgeState==='recorded'&&active)queue.push({id:relation.toRecordId,type:relation.relationshipType,path});
      }
      while(queue.length){
        const current=queue.shift();
        for(const rule of data.membershipImplications.filter(x=>x.enabled&&x.sourceOrganizationId===current.id&&x.eligibleConnectionTypes.includes(current.type))){
          if(current.path.organizationIds.includes(rule.targetOrganizationId))continue;
          const path={organizationIds:[...current.path.organizationIds,rule.targetOrganizationId],relationshipIds:current.path.relationshipIds,implicationIds:[...current.path.implicationIds,rule.id]};
          add(rule.targetOrganizationId,'member_of',path,false);queue.push({id:rule.targetOrganizationId,type:'member_of',path});
        }
      }
      return [...buckets.values()];
    }
    const projected=data.records.map(raw=>{
      const record={id:raw.routeKey,recordId:raw.id,routeKey:raw.routeKey,recordType:raw.recordType,name:raw.displayName,summary:field(raw.id,'overview')?.body};
      record.type=value(raw.id,'person.nature');record.kind=value(raw.id,`${raw.recordType}.kind`);
      record.level=value(raw.id,'power.level');
      const discipline=direct(raw.id).find(x=>x.relationshipType==='power_of');
      if(discipline)record.disciplineId=discipline.toRecordId;
      record.date=value(raw.id,'session.date')?.text;record.affiliationStatus=value(raw.id,'person.affiliationStatus');
      record.category=value(raw.id,'organization.browseCategory');
      const parent=direct(raw.id).find(x=>['contained_in','subgroup_of'].includes(x.relationshipType));
      if(parent)record.parent=rawById.get(parent.toRecordId).routeKey;
      if(raw.recordType==='person'){
        const clan=direct(raw.id).find(x=>x.relationshipType==='clan_member_of');if(clan)record.clan=rawById.get(clan.toRecordId).routeKey;
        record.places=direct(raw.id).filter(x=>x.relationshipType==='associated_with_place').map(x=>rawById.get(x.toRecordId).routeKey);
        const connections=membershipConnections(raw.id);
        const convert=connection=>{
          const target=rawById.get(connection.organizationId);
          const directRelation=direct(raw.id).find(x=>x.toRecordId===target.id&&['member_of','associate_of','affiliated_with'].includes(x.relationshipType));
          return {group:target.routeKey,faction:target.routeKey,organizationId:target.id,role:directRelation?role(directRelation):null,connectionTypes:connection.connectionTypes,direct:connection.direct,paths:connection.paths};
        };
        record.memberships=connections.filter(x=>value(x.organizationId,'organization.browseCategory')!=='political').map(convert);
        record.affiliations=connections.filter(x=>value(x.organizationId,'organization.browseCategory')==='political').map(convert);
      }
      const claim=data.domainClaims.find(x=>x.placeId===raw.id);
      if(claim)record.domain={claimant:claim.claimantRecordId?rawById.get(claim.claimantRecordId).displayName:null};
      record.reviewIssues=(data.reviewIssues||[]).filter(x=>x.recordId===raw.id);
      return record;
    });
    const byId=new Map(projected.map(x=>[x.recordId,x]));
    const collections=Object.fromEntries(Object.entries(routes).map(([type,route])=>[route,projected.filter(x=>x.recordType===type)]));
    const by=(type,id)=>collections[type]?.find(x=>x.id===id||x.recordId===id);
    const canonicalType=record=>routes[record.recordType];
    function related(type,record){
      const sets=Object.fromEntries(Object.keys(collections).map(x=>[x,new Set()]));
      const add=id=>{const target=byId.get(id);if(target&&id!==record.recordId)sets[canonicalType(target)].add(id);};
      for(const relation of data.relationships){
        if(['contained_in','subgroup_of','power_of'].includes(relation.relationshipType))continue;
        if(relation.fromRecordId===record.recordId)add(relation.toRecordId);
        if(relation.toRecordId===record.recordId)add(relation.fromRecordId);
      }
      for(const item of data.items){
        const refs=[item.value?.referenceRecordId,...(item.value?.abilities||[]).map(x=>x.recordId)].filter(Boolean);
        if(item.recordId===record.recordId)for(const id of refs)add(id);
        if(refs.includes(record.recordId))add(item.recordId);
      }
      if(record.recordType==='person')for(const connection of membershipConnections(record.recordId))add(connection.organizationId);
      if(record.recordType==='organization')for(const person of collections.people)if(membershipConnections(person.recordId).some(x=>x.organizationId===record.recordId))add(person.recordId);
      return Object.fromEntries(Object.entries(sets).map(([key,ids])=>[key,[...ids].map(id=>byId.get(id))]));
    }
    function personalRelationships(personId){
      return data.relationships.filter(x=>['associated_with','sire_of','employs'].includes(x.relationshipType)&&rawById.get(x.fromRecordId).recordType==='person'&&rawById.get(x.toRecordId).recordType==='person'&&(x.fromRecordId===personId||x.toRecordId===personId)).map(x=>{
        const from=rawById.get(x.fromRecordId),to=rawById.get(x.toRecordId),type=relationshipTypes.get(x.relationshipType);
        const details=data.items.find(item=>item.subjectRef?.id===x.id&&item.fieldKey==='relationship.details')?.value;
        return {from:from.routeKey,to:to.routeKey,kind:x.relationshipType==='associated_with'?'association':x.relationshipType,label:details|| (x.relationshipType==='associated_with'?null:x.fromRecordId===personId?type.forwardLabel:type.reverseLabel)};
      });
    }
    function searchText(type,record){
      const values=[record.name,record.type,record.kind,record.date,record.affiliationStatus];
      values.push(...data.names.filter(x=>x.recordId===record.recordId).map(x=>x.text));
      for(const item of data.items.filter(x=>x.recordId===record.recordId)) {
        values.push(item.body,typeof item.value==='string'?item.value:null,item.title,item.qualifier,...(item.value?.specialties||[]));
        for(const ability of item.value?.abilities||[])values.push(ability.name,ability.notes,rawById.get(ability.recordId)?.displayName);
      }
      for(const relation of direct(record.recordId))if(!['contained_in','subgroup_of'].includes(relation.relationshipType))values.push(rawById.get(relation.toRecordId)?.displayName);
      if(record.recordType==='person')for(const connection of membershipConnections(record.recordId))values.push(rawById.get(connection.organizationId)?.displayName);
      return values.filter(Boolean).join(' ').toLocaleLowerCase();
    }
    function resolveRoute(input){
      let route=input;const seen=new Set();
      while(true){
        const [path,query='']=route.split('?');
        const key=data.routeAliases[route] ? route : path;
        const target=data.routeAliases[key];if(!target)return route;
        if(seen.has(key))throw new Error('Route alias cycle');seen.add(key);
        const [targetPath,targetQuery='']=target.split('?');
        const params=new URLSearchParams(query);
        for(const [name,value] of new URLSearchParams(targetQuery))params.set(name,value);
        route=targetPath+(params.size?'?'+params.toString():'');
      }
    }
    const tonight={...data.viewConfig.tonight,place:rawById.get(data.viewConfig.tonight.place).routeKey,faces:data.viewConfig.tonight.faces.map(id=>rawById.get(id).routeKey)};
    return {collections,by,byId:id=>byId.get(id),routeFor:canonicalType,itemsFor:id=>data.items.filter(x=>x.recordId===id),sectionsFor:id=>data.sections.filter(x=>x.recordId===id).sort((a,b)=>(a.sortOrder||0)-(b.sortOrder||0)),related,searchText,resolveRoute,membershipConnections,personalRelationships,tonight};
  }
  root.createCampaignModel=createCampaignModel;root.validateCampaign=validateCampaign;
  if(typeof module!=='undefined')module.exports={createCampaignModel,validateCampaign};
})(globalThis);
