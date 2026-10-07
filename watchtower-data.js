// Authored Watchtower notes supplied by the user; no notebook heading is inferred as geography.
(function(D){
  const recordId='place:watchtower',sourceRefs=[{sourceId:'source:watchtower-note'}];
  D.sources.push({id:'source:watchtower-note',sourceKind:'note',label:'User-supplied Watchtower dossier',editorialDate:'2025-01-24'});
  function section(key,heading,sortOrder,displayStyle){
    const id='section:'+recordId+':'+key;
    D.sections.push({id,recordId,templateKey:key,heading,sortOrder,...(displayStyle?{displayStyle}:{})});return id;
  }
  function entry(sectionId,key,body,extra={}){
    const id='item:'+recordId+':'+key;
    D.items.push({id,recordId,sectionId,itemKind:'note',knowledgeState:'recorded',sourceRefs,sortOrder:D.items.filter(x=>x.sectionId===sectionId).length,...(body?{body}:{}),...extra});return id;
  }
  function list(sectionId,key,rows,parentItemId){rows.forEach((body,index)=>entry(sectionId,key+'-'+index,body,{...(parentItemId?{parentItemId}:{})}));}
  const facts=D.sections.find(x=>x.recordId===recordId&&x.templateKey==='facts').id;
  for(const [key,value] of [['place.havenFor','Player coterie'],['place.floorCount',17],['place.businessFloors',14],['place.parkingLevels',4],['place.resourcesBonus','+2 Resources'],['place.securityCoverage','24/7; two officers on site at all times']])entry(facts,key,null,{itemKind:'fact',fieldKey:key,value,valueType:typeof value==='number'?'number':'text'});
  const appearance=section('appearance','Appearance & surroundings',10);
  list(appearance,'appearance',[
    'High rise near the Twig/Hermantown border.',
    'Has offices in it.',
    'On 53, near the intersection with 35N.',
    'Plush haven potential, penthouse office suite.',
    'Good nightlife near it.',
    'Bliss is close by.',
    'Four-level parking ramp.',
    'Lots of security.',
    '17 floors; 14 floors of businesses.'
  ]);
  D.items.find(x=>x.id==='item:'+recordId+':appearance-5').links=[{text:'Bliss',recordId:'place:bliss'}];
  const history=section('history','Building history',11);
  list(history,'history',[
    'High rise with a lake view, built in the 1970s.',
    'Owned by John Smith and his family since it was constructed.'
  ]);
  const ownership=section('ownership','Duluth Property Investors',12);
  list(ownership,'ownership',[
    'Founded in 1903 by John Smith and his brother Edward Smith.',
    'Originally held many properties in West Duluth, including holdings in Morgan Park.',
    'The Smith family maintained ownership of the company the entire time; it was never taken public. The owner list is several Smiths, currently held by John Smith (born in the 1960s).',
    'Over time the amount of property they owned declined, until the 1970s when they sold all but one property and bought land in Hermantown/Twig and built the Watchtower.',
    'Their only other property is an empty lot in West Duluth that used to be the home of the original company founder, John Smith. It burned down in the 1930s in a tragedy involving four deaths.'
  ]);
  const floors=section('floor-directory','Floor directory · 1–14',20,'directory');
  const directory=[
    ['1st Floor — Lobby + Shared Services',[
      'Heirloom Property Management (Watchtower Front Office)',
      'Twin Ports Coffee Roasters — café with outdoor-facing windows and inside seating.',
      'Dock 7 Shipping & Parcel Hub — courier drop-off/pickup, building mailroom, and small P.O. rental center.'
    ]],
    ['2nd Floor — Legal & Financial',[
      'Lake Superior Trust & Credit Union (Branch Office)',
      'O’Connell & Frey, LLP — local law firm specializing in business and municipal law.'
    ]],
    ['3rd Floor — Tech & Startups',[
      'MarbleBox Solutions — app/web development, rumored to be backed by out-of-town investors.',
      'Tower Co-Work Duluth — shared office space, startup incubator vibe.'
    ]],
    ['4th Floor — Health Services',[
      'Dr. M. Jain Psychiatric Consulting — quiet office with late hours.',
      'Lakefront Physical Therapy Group'
    ]],
    ['5th Floor — State & NGO Services',[
      'MN Department of Economic Development — Regional Office',
      'Arrow North Nonprofit Collective — coordinates food, shelter, and youth programs across the region.'
    ]],
    ['6th Floor — Professional Services',[
      'Galloway Insurance & Risk Management',
      'Goldlight Accounting — small but efficient, known for quiet offices and strict deadlines.'
    ]],
    ['7th Floor — Design & Architecture',[
      'Studio Orna — interior design and building restoration consultants.',
      'Northward Architects — specializing in adaptive reuse and energy-efficient design.'
    ]],
    ['8th Floor — Education & Outreach',[
      'Duluth Community Learning Center (Remote Classroom Network)',
      'North Central Mediation Group — civil conflict and HR-focused facilitators.'
    ]],
    ['9th Floor — Media & Marketing',[
      'Harborline Digital — social media and branding for regional businesses.',
      'The Current North (Magazine) — independent lifestyle & culture mag.'
    ]],
    ['10th–11th Floors — Vacant or Transitional Use',[
      'Formerly leased by a regional telecommunications firm; floors are currently undergoing renovation (an opportunity for the coterie?).'
    ]],
    ['12th Floor — Security',[
      'Used as the barracks and base for the new security force.'
    ]],
    ['13th Floor — Heirloom Private Holdings Office',[
      'Very little traffic; locked behind an additional elevator keycard.',
      'Claimed as “archive storage and long term file administration”.',
      'Actually maintained by Portia’s ghoul(s).'
    ]],
    ['14th Floor — Executive / Penthouse Offices',[
      'Currently leased by a shell company: Caliburn Trust LLC.',
      'Furnished but rarely used — potentially being prepared for someone’s future occupancy.'
    ]]
  ];
  directory.forEach(([title,notes],index)=>{
    const parent=entry(floors,'floor-'+index,null,{title});list(floors,'floor-'+index+'-note',notes,parent);
  });
  const privateFloors=section('private-floors','Private floors · 15–17',21,'directory');
  for(const [index,title,notes] of [
    [15,'15th Floor — Private condos',['A fully finished condo floor, leased exclusively to mortals. All units are complete and occupied.']],
    [16,'16th Floor — Conversion',['Converted into private condo units. These were initially built as corporate housing but are now being transitioned into luxury living quarters.']],
    [17,'17th Floor — Private penthouse',['A private, sealed penthouse suite accessible only via keyed elevator or rooftop maintenance stairwell.']]
  ]){const parent=entry(privateFloors,'private-floor-'+index,null,{title});list(privateFloors,'private-floor-'+index+'-note',notes,parent);
    if(index===17){
      const room=entry(privateFloors,'penthouse-layout',null,{title:'Penthouse layout',parentItemId:parent});
      list(privateFloors,'penthouse-layout-note',[
        'A main common area (living room/dining, possible meeting space).',
        'A long hallway leading to two smaller bedrooms, two bathrooms, and one master bedroom suite.',
        'The entire floor is window-lined on one side, with blackout-capable mechanical shades.',
        'Roof access and mechanical systems are tucked behind the master suite.'
      ],room);
    }
  }
  const security=section('security-overview','Security overview',30);
  entry(security,'security-overview','Olivia, Iris’s ghoul and a suspended internal affairs officer, has assembled a discreet, professional private security team to protect the Watchtower. The building requires 24/7 coverage with two officers on-site at all times. The team consists of ten highly trained individuals, all former law enforcement, military, or private contractors. They are loyal, quiet, and handpicked for their reliability and skill.');
  const staffing=section('security-staffing','Security staffing & shifts',31);
  list(staffing,'staffing',[
    'Total staff: 10 officers.',
    'Three daily shifts: 8 AM–4 PM, 4 PM–12 AM, and 12 AM–8 AM.',
    'Minimum coverage: two officers per shift (lobby + garage).',
    'Flexible coverage: a third officer scheduled during nights, weekends, and holidays.'
  ]);
  const budget=section('security-budget','Security budget',32);
  list(budget,'budget',[
    'Average annual salary per officer: $80,000.',
    'Benefits + overhead (20%): $16,000.',
    'Total per officer: $96,000.',
    'Annual budget for security team: $960,000.'
  ]);
  const personnel=section('security-personnel','Security personnel · 10 officers',33,'directory');
  const officers=[
    ['Marcus “Six” Keene (Team Lead Candidate)',42,'Ex Army Ranger, led convoy security teams in Afghanistan.','Tactical response, perimeter lockdowns.','Olivia’s former military academy contact from a corruption case she cleared.'],
    ['Diana Rojas (Team Lead Candidate)',38,'Former SWAT sergeant in Milwaukee PD.','Entry tactics, hostage response, communications.','Friend of a friend from Olivia’s police academy class — vouched for with a glowing warning: “She doesn’t miss.”'],
    ['Reggie “Doc” Marshall',34,'Former private contractor for high-profile corporate clients.','Surveillance systems, counter-intrusion tech.','He handled high-end corporate security contracts; Olivia poached him discreetly after verifying his clean background and quiet efficiency.'],
    ['Callie Jun',29,'Ex Air Force military police, transitioned into cyber forensics.','Network security, threat tracking.','Olivia met her through an encrypted message board for whistleblowers.'],
    ['Wayne Merrick',51,'Retired homicide detective with deep connections.','Interrogation, behavioral profiling.','Former mentor to Olivia before his forced retirement — still sharp, still bitter.'],
    ['Nina Halberg',32,'Israeli Defense Forces, now works freelance with private maritime security.','Firearms, transport defense.','Olivia’s former contact from an international trafficking investigation.'],
    ['Cameron Wells',36,'Former DEA agent turned rogue after exposing internal corruption.','Narcotics detection, covert asset recovery.','Olivia helped him disappear after his whistleblowing went wrong.'],
    ['Trevor “TK” Knight',33,'Former nightclub bouncer turned bodyguard.','Crowd control, muscle.','Met Olivia while handling security at a club.'],
    ['Holly Lasker',28,'Private military contractor, worked surveillance in unstable zones.','Drone recon, sniper overwatch.','Olivia tracked her down via a tip from a friend.'],
    ['Jonas Speer',45,'Former U.S. Marshal, ran witness protection in the upper Midwest.','Discreet relocation, identity management.','Olivia crossed paths with him during a federal leak case — he “owes her one”.']
  ];
  const groupId='organization:watchtower-security';
  function record(id,recordType,routeKey,displayName){
    D.records.push({id,recordType,routeKey,displayName});
    D.names.push({id:'name:'+id+':primary',recordId:id,text:displayName,nameKind:'common',sourceRefs});
  }
  function ownSection(id,key,heading,sortOrder=0){
    const sectionId='section:'+id+':'+key;
    D.sections.push({id:sectionId,recordId:id,templateKey:key,heading,sortOrder});return sectionId;
  }
  function ownItem(id,sectionId,key,extra){D.items.push({id:'item:'+id+':'+key,recordId:id,sectionId,itemKind:'note',knowledgeState:'recorded',sourceRefs,...extra});}
  function relation(key,type,fromRecordId,toRecordId){
    const id='relationship:watchtower-security:'+key;
    D.relationships.push({id,relationshipType:type,fromRecordId,toRecordId,knowledgeState:'recorded',sourceRefs});return id;
  }
  record(groupId,'organization','watchtower-security','Watchtower Security');
  const groupFacts=ownSection(groupId,'facts','Recorded facts');
  ownItem(groupId,groupFacts,'category',{itemKind:'fact',fieldKey:'organization.browseCategory',value:'group',valueType:'text'});
  ownItem(groupId,groupFacts,'kind',{itemKind:'fact',fieldKey:'organization.kind',value:'Security team',valueType:'text'});
  D.relationshipTypes.push({id:'protects',fromTypes:['organization'],toTypes:['place'],forwardLabel:'Protects',reverseLabel:'Protected by',symmetric:false});
  relation('protects','protects',groupId,recordId);
  // Operational details belong to the group, not to ten duplicate character dossiers.
  const overviewSection=ownSection(groupId,'overview','Overview');
  const overview=D.items.find(x=>x.id==='item:'+recordId+':security-overview');
  ownItem(groupId,overviewSection,'overview',{fieldKey:'overview',body:overview.body});
  overview.body='Watchtower Security protects the coterie’s haven. Open the team page for staffing, shifts, budget, and its members.';
  overview.links=[{text:'Watchtower Security',recordId:groupId}];
  for(const sectionId of [staffing,budget]){
    D.sections.find(x=>x.id===sectionId).recordId=groupId;
    for(const item of D.items.filter(x=>x.sectionId===sectionId))item.recordId=groupId;
  }
  const keys=['marcus-keene','diana-rojas','reggie-marshall','callie-jun','wayne-merrick','nina-halberg','cameron-wells','trevor-knight','holly-lasker','jonas-speer'];
  officers.forEach(([title,age,background,specialty,recruited],index)=>{
    const personId='person:'+keys[index],displayName=title.replace(' (Team Lead Candidate)','');
    record(personId,'person',keys[index],displayName);
    const candidate=title.includes('Team Lead Candidate'),role=candidate?'Team lead candidate':'Security officer';
    const facts=ownSection(personId,'facts','Overview');
    ownItem(personId,facts,'age',{itemKind:'fact',fieldKey:'person.age',value:age,valueType:'number'});
    const profile=ownSection(personId,'background','Background & expertise',10);
    for(const [key,heading,body] of [['background','Background',background],['specialty','Specialty',specialty],['recruited','Recruitment',recruited]])ownItem(personId,profile,key,{title:heading,body});
    const membership=relation(keys[index]+':membership','member_of',personId,groupId);
    ownItem(personId,facts,'membership-role',{itemKind:'fact',fieldKey:'relationship.role',value:role,valueType:'text',subjectRef:{kind:'relationship',id:membership}});
    relation(keys[index]+':assignment','associated_with_place',personId,recordId);
    entry(personnel,'officer-'+index,null,{title,titleRecordId:personId});
  });
})(window.CAMPAIGN);
