// Authored public additions. Alan's supplied note was explicitly approved for publication.
// Keep the frozen Phase 1 dataset and migration audit reproducible.
(function (D) {
  const sourceRefs = [{sourceId:'source:alan-public-note'}];
  D.sources.push({id:'source:alan-public-note',sourceKind:'note',label:'Alan Sovereign — author-approved public note',editorialDate:'2024-11-27'});
  function record(id,recordType,routeKey,displayName) {
    D.records.push({id,recordType,routeKey,displayName});
    D.names.push({id:`name:${id}:primary`,recordId:id,text:displayName,nameKind:'common',sourceRefs});
  }
  function section(recordId,key,heading,sortOrder) {
    const id=`section:${recordId}:${key}`;
    D.sections.push({id,recordId,templateKey:key,heading,sortOrder});return id;
  }
  function entry(recordId,sectionId,key,body,extra={}) {
    const row={id:`item:${recordId}:${key}`,recordId,sectionId,itemKind:'note',body,knowledgeState:'recorded',sourceRefs,sortOrder:D.items.filter(x=>x.sectionId===sectionId).length,...extra};
    if(body===null)delete row.body;
    D.items.push(row);return row.id;
  }
  function fact(recordId,key,value,extra={}) {
    const sectionId=D.sections.find(x=>x.recordId===recordId&&x.templateKey==='facts').id;
    entry(recordId,sectionId,key,null,{itemKind:'fact',fieldKey:key,value,valueType:typeof value==='number'?'number':'text',...extra});
  }
  function relation(id,relationshipType,fromRecordId,toRecordId) {
    D.relationships.push({id,relationshipType,fromRecordId,toRecordId,knowledgeState:'recorded',sourceRefs});return id;
  }
  function type(id,fromTypes,toTypes,forwardLabel,reverseLabel,symmetric=false) {
    if(!D.relationshipTypes.some(x=>x.id===id))D.relationshipTypes.push({id,fromTypes,toTypes,forwardLabel,reverseLabel,symmetric});
  }
  record('person:alan-sovereign','person','alan-sovereign','Alan Sovereign');
  record('clan:ventrue','clan','ventrue','Ventrue');
  record('organization:camarilla','organization','camarilla','Camarilla');
  const orgFacts=section('organization:camarilla','facts','Recorded facts',0);
  entry('organization:camarilla',orgFacts,'category',null,{itemKind:'fact',fieldKey:'organization.browseCategory',value:'political',valueType:'text'});
  // Linked people get minimal records. Their identities and unspecified fields are not invented.
  for(const [key,name] of [['horatio-ballard','Horatio Ballard'],['ingrid-fallon','Ingrid Fallon'],['marlon-falcone','Marlon Falcone'],['kevin-jackson','Kevin Jackson'],['aluc-romas-de-leon','Aluc Romas de Leon']])record('person:'+key,'person',key,name);
  for(const [key,name,kind] of [['alan-east-duluth-townhouse','East Duluth townhouse','Townhouse'],['loop','The L(oop)','Territory']]) {
    const id='place:'+key;record(id,'place',key,name);section(id,'facts','Recorded facts',0);fact(id,'place.kind',kind);
  }
  // The exact containing districts of these sites have not been supplied.
  const A='person:alan-sovereign';
  D.names.push({id:'name:alan:the-money',recordId:A,text:'the Money',nameKind:'alias',context:'Bankers and property moguls',sourceRefs});
  section(A,'facts','Overview',0);
  fact(A,'person.nature','Kindred');
  fact(A,'person.ambition','Wrest power (and potentially soul) from Horatio Ballard',{links:[{text:'Horatio Ballard',recordId:'person:horatio-ballard'}]});
  fact(A,'person.humanity',5);fact(A,'person.generation','9th');fact(A,'person.bloodPotency',3);fact(A,'person.health',6);fact(A,'person.willpower',4);
  relation('relationship:alan:clan','clan_member_of',A,'clan:ventrue');
  const affiliation=relation('relationship:alan:camarilla','affiliated_with',A,'organization:camarilla');
  const affiliationSection=section(A,'affiliation-notes','Affiliation notes',1);
  entry(A,affiliationSection,'seneschal',null,{itemKind:'fact',fieldKey:'relationship.role',subjectRef:{kind:'relationship',id:affiliation},value:'Seneschal',valueType:'text'});
  // This does not merge the global Camarilla with the existing Duluth Camarilla record.
  const convictions=section(A,'convictions','Convictions',10);
  entry(A,convictions,'conviction-1','Never kill a vessel.');entry(A,convictions,'conviction-2','Always remember my origins.');
  const touchstones=section(A,'touchstones','Touchstones',11);
  type('has_touchstone',['person'],['person'],'Touchstone','Touchstone of');
  relation('relationship:alan:touchstone:ingrid','has_touchstone',A,'person:ingrid-fallon');
  relation('relationship:alan:touchstone:marlon','has_touchstone',A,'person:marlon-falcone');
  entry(A,touchstones,'touchstone-ingrid','Ingrid Fallon — Personal Assistant',{links:[{text:'Ingrid Fallon',recordId:'person:ingrid-fallon'}]});
  entry(A,touchstones,'touchstone-marlon','Marlon Falcone — Imprisoned former associate',{links:[{text:'Marlon Falcone',recordId:'person:marlon-falcone'}]});
  const attributes=section(A,'attributes','Attributes',2);
  for(const [name,rating] of [['Strength',1],['Dexterity',3],['Stamina',3],['Charisma',3],['Manipulation',5],['Composure',2],['Intelligence',5],['Wits',3],['Resolve',2]])entry(A,attributes,'attribute-'+name.toLowerCase(),null,{itemKind:'mechanic',fieldKey:'mechanics.attribute',title:name,value:{rating},valueType:'rating'});
  const skills=section(A,'skills','Skills',3);
  for(const [name,rating,specialty] of [['Brawl',1],['Drive',2],['Melee',2],['Larceny',2,'Stock Manipulation'],['Etiquette',3],['Insight',2],['Intimidation',1],['Leadership',3],['Persuasion',4],['Streetwise',1],['Subterfuge',4],['Academics',3,'Economics'],['Finance',5,'Stock Market'],['Investigation',4],['Politics',2],['Technology',2,'Computers']])entry(A,skills,'skill-'+name.toLowerCase(),null,{itemKind:'mechanic',fieldKey:'mechanics.skill',title:name,value:{rating,specialties:specialty?[specialty]:[]},valueType:'rating'});
  const disciplines=section(A,'disciplines','Disciplines',4);
  for(const [name,rating] of [['Auspex',2],['Dominate',4],['Fortitude',3],['Presence',2]])entry(A,disciplines,'discipline-'+name.toLowerCase(),null,{itemKind:'mechanic',fieldKey:'mechanics.discipline',title:name,value:{rating,referenceRecordId:null,abilities:[]},valueType:'discipline_rating'});
  const appearance=section(A,'mask-and-mien','Mask and Mien',12);
  entry(A,appearance,'appearance-1','Pinched face, drawn in tight around a thin, pointy nose. Skin is sallow and wrinkled and he has been described as looking like a weasel. Hair is white and combed over to cover the bald spot. Several pairs of designer spectacles he takes great care in polishing. Wears expensive suits. Very concerned with how they talk about him and view him.');
  entry(A,appearance,'appearance-2','Voice is somewhat squeaky and his words quickly spoken. Gives the impression of someone with high blood pressure and a heart to match. Fingers often steepled together in front of him as though in constant prayer or reflection.');
  entry(A,appearance,'appearance-3','Through his assistant, maintains control over several prominent financiers. Bankers and property moguls in the loop refer to him as "the Money" and his identity is a source of water cooler rumor at the highest levels of companies.');
  const tools=section(A,'thralls-and-tools','Thralls and Tools',13);
  entry(A,tools,'ingrid','Personal assistant. Ghoul. Most trusted mortal companion. Maintains many of his public personas. Often says she is his finest acquisition, but refuses to embrace her.',{title:'Ingrid Fallon',titleRecordId:'person:ingrid-fallon'});
  entry(A,tools,'hired-hands','Can call upon a veritable horde of hirelings to do his bidding.',{title:'Hired Hands'});
  const ingridFacts=section('person:ingrid-fallon','facts','Recorded facts',0);fact('person:ingrid-fallon','person.nature','Ghoul');
  relation('relationship:alan:employs:ingrid','employs',A,'person:ingrid-fallon');
  const relationships=section(A,'relationships','Relationships',14);
  const connections=[
    ['kevin','person:kevin-jackson','Kevin Jackson','Esteem',[
      "Closest and most amiable relationship. Holds the Prince in great esteem for maintaining his position as Seneschal since Lodin's death."
    ]],
    ['aluc','person:aluc-romas-de-leon','Aluc Romas de Leon','Business',[
      'A valuable business associate. Keeps him apprised of any inspired and valuable pieces that become available to invest in.'
    ]],
    ['horatio','person:horatio-ballard','Horatio Ballard','Hatred',[
      "Maintains a close watch for any signs of his reclusive sire's return to court.",
      "Has worked hard to recover his position of influence and doesn't want the old toad pulling it out from under him.",
      'Continually briefs the Prince against him, subtly, with tales of his wastefulness.'
    ]]
  ];
  for(const [key,target,title,label,notes] of connections){
    if(key!=='horatio')relation('relationship:alan:'+key,'associated_with',A,target);
    const parent=entry(A,relationships,'relationship-'+key,null,{title:title+' — '+label,titleRecordId:target,perspectiveRecordId:A});
    for(const [index,note] of notes.entries())entry(A,relationships,`relationship-${key}-${index}`,note,{parentItemId:parent,perspectiveRecordId:A});
  }
  relation('relationship:horatio:sire-of-alan','sire_of','person:horatio-ballard',A);
  const plots=section(A,'plots','Plots and Schemes',15);
  for(const [key,title,notes] of [
    ['property','Property Magnate',[
      'Current posture is toward investing in the tangible. Plunges more and more of his paper wealth into material, especially artworks and property.',
      'Hopes to foster good relations with the Toreador.'
    ]],
    ['stars','Dancing with the Stars',[
      'Shows great kindness and friendship to any Kindred he meets who he thinks can get him an in with important members of the court or who have financial contacts outside the city.',
      'Makes his friends his friends even.',
      'Will show great interest in anyone who wishes to talk to him about it and will seek to indebt them to him financially or by boon.'
    ]],
    ['patricide','Dreams of Patricide',[
      'Wants to destroy his sire.',
      "Has heard tales that the drinking of the blood of one's sire adds their power to your own and he feels he could finally make himself safe.",
      'Also has enough knowledge of his business empire to take control.'
    ]],
    ['landlord','The Landlord',[
      'He is an easy source of finance to Kindred and is the landlord for many younger Kindred and even coteries seeking shelter.',
      'Many stories of Kindred who find themselves weighted down in the bottom of the lake when they awoke one night after failing to make the payments.'
    ]]
  ]) {
    const parent=entry(A,plots,'plot-'+key,null,{title,itemKind:'note'});
    for(const [index,note] of notes.entries())entry(A,plots,`plot-${key}-${index}`,note,{parentItemId:parent});
  }
  const whispers=section(A,'whispers','Whispers',16);
  entry(A,whispers,'whisper-1','His old house in East Duluth is lavished in fine decor and priceless art works. Some have noticed he seems to regularly sell the pieces, though he has taken on a second job as a dealer.',{itemKind:'rumor',knowledgeState:'rumor'});
  entry(A,whispers,'whisper-2','He has become an infrequent visitor at the Succubus Club. Anyone who has seen him there says he looks like a fish out of water, but he keeps going.',{itemKind:'rumor',knowledgeState:'rumor'});
  entry(A,whispers,'whisper-3','He is one of the chief worriers at court regarding the Second Inquisition and supports any endeavor aimed at curtailing their activities. A couple younger Kindred in the city suspect he may have been spoken into turning rat for them.',{itemKind:'rumor',knowledgeState:'rumor'});
  const domain=section(A,'domain-and-haven','Domain and Haven',17);
  entry(A,domain,'townhouse','Plush, sandstone townhouse. Often holds court there for groups of handpicked up and coming Kindred and introduces them to the lavish lifestyle that can be theirs as members of the Camarilla. If they follow his instructions.',{title:'East Duluth townhouse',titleRecordId:'place:alan-east-duluth-townhouse'});
  entry(A,domain,'loop','He sees the loop as his personal domain. Owns large parts of the finance industry in the area.',{title:'The L(oop)',titleRecordId:'place:loop'});
  relation('relationship:alan:townhouse','associated_with_place',A,'place:alan-east-duluth-townhouse');
  relation('relationship:alan:loop','associated_with_place',A,'place:loop');
  D.domainClaims.push({id:'claim:alan:loop',placeId:'place:loop',claimantRecordId:A,status:'asserted',sourceRefs});
  const mortal=section(A,'mortal-history','Mortal History',18);
  for(const [index,note] of [
    'Born 1903.',
    'Made his money on the backs of returning WWII vets via home loan programs.',
    'He invested into property and made more wealth and influence.',
    'Eventually became president of a small investment bank.',
    'Was imprisoned by the IRS and had wealth, status and lifestyle stripped from him and was put into a low security jail.',
    'On his first night out, he was approached by men employed by Horatio Ballard, who promised him revenge against his captors.',
    'Gave Alan 750k to invest but had to repay it with lots of interest soon.',
    'He doubled the stake and was taken as a ghoul.'
  ].entries())entry(A,mortal,'mortal-'+index,note,{links:[{text:'Horatio Ballard',recordId:'person:horatio-ballard'}]});
  const vampire=section(A,'vampire-history','Vampire History',19);
  for(const [index,note] of [
    'Embraced in 1959 by Horatio Ballard.',
    "His first act was to eliminate several IRS agents who had prosecuted his case. This wasn't enough. The system had to suffer.",
    "Continued as Ballard's lieutenant and minded his portfolio, rising to Seneschal when the Primogen Council steered the city.",
    "Drew political figures and government regulators into his pockets, and used them to drive his personal finance sector to the wall and profit from it. It was mostly other people's money, though.",
    'The losses he made in driving his former rivals and enemies into the dirt were borne from his own pocket. Ballard\'s trust in him was shaken and he removed many of his privileges.',
    'He realized he was wholly reliant on the bank accounts of others.',
    'He took what little he owned and invested with external clan and sect interests among the Giovanni. It paid off for a time, a recent correspondence has not been replied to.',
    'He looks for new allies inside the city. He fears a stagnation though.',
    'Whispers of the 2nd Inquisition fill him with dread, fearing his dealing with the Giovanni have betrayed him.',
    "Secretly visits his old business associate Marlon, who has been committed to a mental hospital since he believes the ghost of his long dead friend Alan is visiting him. They discuss the old days but also future plans."
  ].entries())entry(A,vampire,'vampire-'+index,note,{links:[{text:'Horatio Ballard',recordId:'person:horatio-ballard'},{text:'Marlon',recordId:'person:marlon-falcone'}]});
  // Confirmed geography corrections; retain record IDs and all other connections.
  D.sources.push({id:'source:twig-location-corrections',sourceKind:'user-confirmation',label:'Pink Slips and Blacklight are in Twig'});
  for(const id of ['place:pink-slips','place:blacklight']){
    const containment=D.relationships.find(x=>x.fromRecordId===id&&x.relationshipType==='contained_in');
    containment.toRecordId='place:twig';
    containment.sourceRefs=[{sourceId:'source:twig-location-corrections'}];
  }
  D.viewConfig.tonight.heroImage={src:'assets/duluth night.jpg',alt:'Duluth harbor and the illuminated Aerial Lift Bridge at night.'};
})(window.CAMPAIGN);
