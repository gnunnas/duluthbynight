window.CAMPAIGN={
people:[
{id:"kyra",name:"Kyra Ripa",type:"Kindred",clan:"toreador",affiliations:[{faction:"duluth-camarilla",role:null}],places:["bliss"],summary:"Toreador tied to Bliss and the Circulatory System. The coterie has agreed she has to go."},
{id:"spokes",name:"Spokes",type:"Kindred",clan:"nosferatu",memberships:[{group:"spokes-crew",role:null}],summary:"An impeccably dressed early-1900s Nosferatu who rides a black penny-farthing with supernatural speed. He has agreed to find Kyra's haven."},
{id:"chains",name:"Chains",type:"Kindred",memberships:[{group:"spokes-crew",role:null}],summary:"Stocky, massively bearded, patched leather vest. His chromed bicycle has ape hangers and a skull over the reflector."},
{id:"freewheel",name:"Freewheel",type:"Kindred",memberships:[{group:"spokes-crew",role:null}],summary:"Head-to-toe denim, tattoos, and a cigarette rolled into his sleeve."},
{id:"pedals",name:"Pedals",type:"Kindred",memberships:[{group:"spokes-crew",role:null}],summary:"Mullet, handlebar mustache, and a patchwork leather vest with nothing underneath."},
{id:"big-chain",name:"Big Chain",type:"Kindred",memberships:[{group:"spokes-crew",role:null}],summary:"Nearly seven feet tall and built like a freight train. Somehow rides a tiny bicycle with training wheels."},
{id:"portia",name:"Portia",type:"Kindred",clan:"tremere",affiliations:[{faction:"duluth-camarilla",role:null}],places:["chantry"],summary:"A sharp Tremere acquaintance of Iris. She connected the Nopeming mystery to whispers of the Bahari and invited Iris to the Chantry library."},
{id:"sydney",name:"Sydney",type:"Kindred",affiliationStatus:"Independent",places:["pink-slips"],summary:"Rebecca's sire. She introduced the coterie to Spokes and his crew."},
{id:"georgia",name:"Georgia Stein",type:"Mortal",memberships:[{group:"bliss",role:null}],places:["bliss"],summary:"A mortal closely connected to Bliss and Kyra."},
{id:"nora",name:"Nora",type:"Thin-Blood",memberships:[{group:"night-forum",role:null}],summary:"Thin-Blood friend and Night Forum associate."},
{id:"lucas",name:"Lucas",type:"Ghoul",affiliations:[{faction:"duluth-camarilla",role:null}],summary:"A ghoul who has served as an intermediary for dangerous business."}
],
places:[
{id:"duluth",name:"Duluth",kind:"City",summary:"Camarilla capital on Lake Superior.",children:["downtown","umd","eldes-corner"]},
{id:"superior",name:"Superior",kind:"City",summary:"Wisconsin city with significant Tremere influence.",children:["billings"]},
{id:"wrenshall",name:"Wrenshall",kind:"City",summary:"Anarch territory south of Duluth."},
{id:"twig",name:"Twig",kind:"Community",summary:"Industrial satellite with Anarch leanings.",children:["crimson-roots"]},
{id:"downtown",name:"Downtown & Waterfront",kind:"District",parent:"duluth",summary:"Harbor, nightlife, skywalks, tunnels, and the coterie's growing domain.",children:["watchtower","bliss","rack","pink-slips","blacklight"]},
{id:"umd",name:"UMD / East Duluth",kind:"District",parent:"duluth",children:["critias-umd"],summary:"University district and Critias's sphere of influence."},
{id:"eldes-corner",name:"Eldes Corner",kind:"Suburb",parent:"duluth",children:["nopeming"],summary:"A suburb of Duluth in the campaign setting."},
{id:"nopeming",name:"Nopeming Sanatorium",kind:"Site",parent:"eldes-corner",summary:"Beneath the abandoned sanatorium, a long wet stair descends toward black water and the things that call from below."},
{id:"watchtower",name:"The Watchtower",kind:"Building",domain:{claimant:null},parent:"downtown",summary:"The coterie's 17-floor home and operational base."},
{id:"bliss",name:"Bliss",kind:"Nightclub",parent:"downtown",summary:"Kyra's club, only blocks from the coterie's territory—and a prize worth taking."},
{id:"rack",name:"The Rack",kind:"Territory",parent:"downtown",summary:"Duluth's connected skywalk and tunnel network after dark."},
{id:"pink-slips",name:"Pink Slips",kind:"Bar",parent:"downtown",summary:"Where Sydney introduced the coterie to Spokes and his bicycle gang."},
{id:"blacklight",name:"Blacklight",kind:"Nightclub",parent:"downtown",summary:"The coterie met Portia here in a private VIP room overlooking the dance floor."},
{id:"billings",name:"Billings Park",kind:"District",parent:"superior",children:["chantry"],summary:"Superior neighborhood containing the Tremere Chantry."},
{id:"chantry",name:"Tremere Chantry",kind:"Haven",parent:"billings",summary:"The Tremere stronghold in Superior. Portia invited Iris alone to research its library."},
{id:"critias-umd",name:"Critias at UMD",kind:"Site",parent:"umd",summary:"Critias's academic foothold at the university."},
{id:"crimson-roots",name:"Crimson Roots Wellness",kind:"Business",parent:"twig",summary:"A coterie asset in Twig."}
],
threads:[
{id:"kyra-hunt",name:"The Hunt for Kyra",summary:"Spokes and his crew are trying to find Kyra's haven and map her security. Removing her could put Bliss within the coterie's reach.",people:["kyra","spokes","sydney","georgia"],places:["bliss","pink-slips"]},
{id:"dark-mother",name:"The Dark Mother",summary:"The creatures beneath Nopeming spoke of a Dark Mother and an ancient enemy. Portia suspects a connection to the Bahari and Lilith.",people:["portia"],places:["nopeming","blacklight","chantry"]},
{id:"maxwell",name:"Maxwell's Offer",summary:"The coterie intends to string Maxwell along while bringing what they learn to Prince Jackson, hoping to gain politically without committing too early."},
{id:"lasombra",name:"The Lasombra Gambit",summary:"Sylens is working with Sierra as she maneuvers to bring the Lasombra into the Camarilla, even offering older members of her clan as proof of loyalty."}
],
sessions:[
{id:"2026-09-11",date:"September 11",title:"Chains in the Dark",summary:"The coterie hired Spokes and his bizarre bicycle gang to hunt Kyra's haven, then met Portia at Blacklight to investigate the sigils beneath Nopeming and the whispered Bahari connection."}
]};
// Stable IDs separate lineage, membership, and political affiliation.
window.CAMPAIGN.clans = [
  {id:'toreador',name:'Toreador'},
  {id:'nosferatu',name:'Nosferatu'},
  {id:'tremere',name:'Tremere'}
];
window.CAMPAIGN.groups = [
  {id:'spokes-crew',name:'Spokes Crew',kind:'Crew',parent:null},
  {id:'night-forum',name:'Night Forum',kind:null,parent:null},
  {id:'bliss',name:'Bliss',kind:'Business association',parent:null,places:['bliss']}
];
window.CAMPAIGN.factions = [
  {id:'duluth-camarilla',name:'Duluth Camarilla',parent:null}
];
// The previous related-person links establish association, not its exact nature.
window.CAMPAIGN.relationships = [
  {id:'spokes-chains',from:'spokes',to:'chains',kind:'association',label:null},
  {id:'spokes-freewheel',from:'spokes',to:'freewheel',kind:'association',label:null},
  {id:'spokes-pedals',from:'spokes',to:'pedals',kind:'association',label:null},
  {id:'spokes-big-chain',from:'spokes',to:'big-chain',kind:'association',label:null}
];
// Preserve bookmarked faction URLs after correcting their classification.
window.CAMPAIGN.legacyRoutes = {
  'factions/spokes-crew':'groups/spokes-crew',
  'factions/night-forum':'groups/night-forum',
  'factions/bliss':'groups/bliss',
  'factions/independent':'search?q=Independent'
};
// Links supported by the existing session summary.
Object.assign(window.CAMPAIGN.sessions[0], {
  people: ['spokes', 'chains', 'freewheel', 'pedals', 'big-chain', 'kyra', 'portia'],
  places: ['blacklight', 'nopeming'],
  threads: ['kyra-hunt', 'dark-mother']
});
window.CAMPAIGN.tonight = {
  status: [['Current night', 'After Sept. 11'], ['Coterie status', 'Playing Both Sides'], ['Current lead', "Kyra’s Haven"], ['Next stop', 'Chantry Library']],
  place: 'blacklight',
  summary: 'The coterie met Portia to investigate the sigils and drowned creatures beneath Nopeming. She connected their discoveries to whispers of the Bahari and invited Iris alone to continue the research at the Tremere Chantry.',
  followup: "Meanwhile, Spokes and his bicycle gang are hunting for Kyra’s haven and mapping her security.",
  faces: ['spokes', 'portia', 'kyra']
};
