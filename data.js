window.CAMPAIGN={
people:[
{id:"kyra",name:"Kyra Ripa",type:"Kindred",clan:"Toreador",faction:"Duluth Camarilla",place:"bliss",summary:"Toreador tied to Bliss and the Circulatory System. The coterie has agreed she has to go."},
{id:"spokes",name:"Spokes",type:"Kindred",clan:"Nosferatu",faction:"Spokes Crew",summary:"An impeccably dressed early-1900s Nosferatu who rides a black penny-farthing with supernatural speed. He has agreed to find Kyra's haven.",related:["chains","freewheel","pedals","big-chain"]},
{id:"chains",name:"Chains",type:"Kindred",faction:"Spokes Crew",summary:"Stocky, massively bearded, patched leather vest. His chromed bicycle has ape hangers and a skull over the reflector."},
{id:"freewheel",name:"Freewheel",type:"Kindred",faction:"Spokes Crew",summary:"Head-to-toe denim, tattoos, and a cigarette rolled into his sleeve."},
{id:"pedals",name:"Pedals",type:"Kindred",faction:"Spokes Crew",summary:"Mullet, handlebar mustache, and a patchwork leather vest with nothing underneath."},
{id:"big-chain",name:"Big Chain",type:"Kindred",faction:"Spokes Crew",summary:"Nearly seven feet tall and built like a freight train. Somehow rides a tiny bicycle with training wheels."},
{id:"portia",name:"Portia",type:"Kindred",clan:"Tremere",faction:"Duluth Camarilla",place:"chantry",summary:"A sharp Tremere acquaintance of Iris. She connected the Nopeming mystery to whispers of the Bahari and invited Iris to the Chantry library."},
{id:"sydney",name:"Sydney",type:"Kindred",faction:"Independent",place:"pink-slips",summary:"Rebecca's sire. She introduced the coterie to Spokes and his crew."},
{id:"georgia",name:"Georgia Stein",type:"Mortal",faction:"Bliss",place:"bliss",summary:"A mortal closely connected to Bliss and Kyra."},
{id:"nora",name:"Nora",type:"Thin-Blood",faction:"Night Forum",summary:"Thin-Blood friend and Night Forum associate."},
{id:"lucas",name:"Lucas",type:"Ghoul",faction:"Duluth Camarilla",summary:"A ghoul who has served as an intermediary for dangerous business."}
],
places:[
{id:"duluth",name:"Duluth",kind:"City",summary:"Camarilla capital on Lake Superior.",children:["downtown","umd","nopeming"]},
{id:"superior",name:"Superior",kind:"City",summary:"Wisconsin city with significant Tremere influence.",children:["billings"]},
{id:"wrenshall",name:"Wrenshall",kind:"City",summary:"Anarch territory south of Duluth."},
{id:"twig",name:"Twig",kind:"Community",summary:"Industrial satellite with Anarch leanings.",children:["crimson-roots"]},
{id:"downtown",name:"Downtown & Waterfront",kind:"District",parent:"duluth",summary:"Harbor, nightlife, skywalks, tunnels, and the coterie's growing domain.",children:["watchtower","bliss","rack","pink-slips","blacklight"]},
{id:"umd",name:"UMD / East Duluth",kind:"District",parent:"duluth",children:["critias-umd"],summary:"University district and Critias's sphere of influence."},
{id:"nopeming",name:"Nopeming Sanatorium",kind:"Site",parent:"duluth",summary:"Beneath the abandoned sanatorium, a long wet stair descends toward black water and the things that call from below."},
{id:"watchtower",name:"The Watchtower",kind:"Domain",parent:"downtown",summary:"The coterie's 17-floor home and operational base."},
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