// User-supplied discipline reference notes, separate from NPC ratings and presentation.
(function(D){
  const sourceRefs=[{sourceId:'source:discipline-notes'}];
  D.sources.push({id:'source:discipline-notes',sourceKind:'note',label:'User-supplied discipline notebook',editorialDate:'2025-01-04'});
  function record(id,recordType,routeKey,displayName){
    D.records.push({id,recordType,routeKey,displayName});
    D.names.push({id:'name:'+id+':primary',recordId:id,text:displayName,nameKind:'common',sourceRefs});
    D.sections.push({id:'section:'+id+':facts',recordId:id,templateKey:'facts',heading:'Reference fields',sortOrder:0});
  }
  function field(id,key,value){
    D.items.push({id:'item:'+id+':'+key,recordId:id,sectionId:'section:'+id+':facts',itemKind:typeof value==='number'?'fact':'note',fieldKey:key,...(typeof value==='number'?{value,valueType:'number'}:{body:value}),knowledgeState:'recorded',sourceRefs});
  }
  for(const name of ['Animalism','Auspex','Dominate','Fortitude','Presence'])record('discipline:'+name.toLowerCase(),'discipline',name.toLowerCase(),name);
  D.relationshipTypes.push({id:'power_of',fromTypes:['power'],toTypes:['discipline'],forwardLabel:'Ability of',reverseLabel:'Contains ability',symmetric:false});
  const levels=[
    ['Bond Famulus','Sense The Beast'],
    ['Animal Messenger','Feral Whispers'],
    ['Animal Succulence',"Messenger’s Command",'Plague of Beasts','Quell The Beast','Unliving Hive'],
    ['Subsume the Spirit','Sway the Flock'],
    ['Animal Dominion','Drawing Out the Beast']
  ];
  levels.forEach((names,index)=>names.forEach(name=>{
    const slug=name.toLowerCase().replace(/[’']/g,'').replace(/[^a-z0-9]+/g,'-');
    const id='power:animalism:'+slug;
    record(id,'power','animalism-'+slug,name);field(id,'power.level',index+1);
    D.relationships.push({id:'relationship:'+id+':discipline',relationshipType:'power_of',fromRecordId:id,toRecordId:'discipline:animalism',knowledgeState:'recorded',sourceRefs});
  }));
  const sense='power:animalism:sense-the-beast';
  field(sense,'overview','The vampire can sense the Beast present in mortals, vampires, and other super naturals, gaining a sense of their nature, hunger, and hostility.');
  field(sense,'power.cost','Free');
  field(sense,'power.dicePools','Resolve + Animalism vs Composure + Subterfuge');
  field(sense,'power.system','Roll Resolve + Animalism vs Composure + Subterfuge. A win allows the user to sense the level of hostility in a target (whether the person is prepared to do harm or even determined to cause it) and determine whether they harbor a supernatural Beast, marking them as a vampire or werewolf. On a win, a critical gives the user information on the exact type of creature (for example, a mage, a werewolf), as well as their Hunger (or equivalent) level, and their Resonance. This power can be used both actively and passively, warning the user of aggressive intent in their immediate vicinity.');
  field(sense,'power.duration','Passive');
  const heightened='power:auspex:heightened-senses';
  record(heightened,'power','auspex-heightened-senses','Heightened Senses');
  field(heightened,'power.level',1);
  D.relationships.push({id:'relationship:'+heightened+':discipline',relationshipType:'power_of',fromRecordId:heightened,toRecordId:'discipline:auspex',knowledgeState:'recorded',sourceRefs});
  field(heightened,'overview',"The vampire’s senses sharpen to a preternatural degree, giving them the ability to see in pitch darkness, hear ultrasonic frequencies and smell the fear of cowering prey.");
  field(heightened,'power.cost','Free (but see below)');
  field(heightened,'power.dicePools','Wits + Resolve');
  field(heightened,'power.system','The user adds their Auspex rating to all perception rolls. If exposed to extreme sensations, such as loud bangs, flashes of intense light or overpowering smells while the power is active, the user must succeed on a Wits + Resolve (Difficulty 3 or more) roll to dampen their senses in time, or the overload causes them to sustain a -3 dice penalty to all perception-based rolls for the rest of the scene.');
  field(heightened,'power.duration',"Until deactivated. Having the power active for longer stretches of time without rest (more than a scene), especially for high-stimulus environments, might necessitate spending Willpower, at the Storyteller’s discretion.");
  const alanAuspex=D.items.find(x=>x.recordId==='person:alan-sovereign'&&x.fieldKey==='mechanics.discipline'&&x.title==='Auspex');
  alanAuspex.value.abilities.push({recordId:heightened});
  // Link existing recorded ratings; a rating never selects abilities automatically.
  for(const item of D.items.filter(x=>x.fieldKey==='mechanics.discipline')){
    const discipline=D.records.find(x=>x.recordType==='discipline'&&x.displayName===item.title);
    if(discipline&&!item.value.referenceRecordId)item.value.referenceRecordId=discipline.id;
  }
})(window.CAMPAIGN);
