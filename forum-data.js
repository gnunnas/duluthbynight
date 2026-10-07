// Public, fictional forum conversations authored from the supplied Verumdetenebris premise.
// This is set dressing, separate from campaign records and Storyteller investigation notes.
window.VERUM_FORUM={
 groups:[
  {id:'everyday',name:'THE ORDINARY WORLD',description:'Even truth-seekers have to eat.',boards:[
   {id:'dinner',name:'What did you have for dinner?',description:'Recipes, questionable leftovers, and midnight snacks.'},
   {id:'cats',name:'Show me your cat photos!',description:'The only creatures here we trust. Mostly.'}]},
  {id:'sightings',name:'THE STRANGE NORTH',description:'Something moved. You saw it. Tell us.',boards:[
   {id:'harbor',name:'Werewolf spotted at the harbor?',description:'Dockside sightings, large footprints, very bad photographs.'},
   {id:'sky',name:'UFOs, lake monsters & other evidence',description:'Lights above the lake. Things below it.'}]},
  {id:'night',name:'AFTER THE SUN GOES DOWN',description:'For those who have started asking different questions.',boards:[
   {id:'vampires',name:'How to protect yourself against vampires',description:'Field notes, folklore, and suggestions we hope you never need.'},
   {id:'patterns',name:'Patterns & unanswered questions',description:'Compare dates. Keep copies. Be polite.'}]}],
 threads:[
  {id:'soup',board:'dinner',title:'Soup at 1 a.m. counts as dinner, right?',stamp:'Apr 12 · 11:38 PM',posts:[
   ['DarkDescent','Apr 12 · 11:38 PM','Tomato soup. Crackers. The blue glow of a monitor. A balanced meal if you include the crackers as a separate food group.'],
   ['dialup_doris','Apr 12 · 11:46 PM','Grilled cheese is mandatory. This is the only absolute truth on this entire website.'],
   ['DarkDescent','Apr 12 · 11:53 PM','UPDATE: grilled cheese acquired. The search for truth continues.']]},
  {id:'garlic-bread',board:'dinner',title:'IMPORTANT: garlic bread is not a complete defense strategy',stamp:'May 11 · 10:42 PM',posts:[
   ['DarkDescent','May 11 · 10:42 PM','Posting this here because the other board got heated. Enjoy your garlic bread. Do not confuse enjoying garlic bread with being adequately prepared.'],
   ['hotdish_hank','May 11 · 10:57 PM','Prepared for WHAT? I thought this was the dinner board.'],
   ['DarkDescent','May 11 · 11:04 PM','Unexpected guests. Also hunger. Mostly unexpected guests.']]},
  {id:'freezer',board:'dinner',title:'The mystery container at the back of the freezer',stamp:'Feb 10 · 8:19 PM',posts:[
   ['hotdish_hank','Feb 10 · 8:19 PM','Label says CHILI? Question mark included. It has been there since winter. Looking for a second opinion.'],
   ['DarkDescent','Feb 10 · 8:33 PM','Some mysteries are meant to remain sealed.'],
   ['dialup_doris','Feb 10 · 8:41 PM','Please do not move this into Cryptids again.']]},
  {id:'cat-monitor',board:'cats',title:'My cat is trying to contact the mothership',stamp:'Jan 12 · 9:06 PM',posts:[
   ['DarkDescent','Jan 12 · 9:06 PM','Every time the modem connects she sits on it and screams. Attached: compelling photographic evidence.'],
   ['mothman_mom','Jan 12 · 9:18 PM','The picture will not load. I believe her anyway.'],
   ['DarkDescent','Jan 12 · 9:31 PM','The file is called cat_final_FINAL2.gif. Please stop asking for a higher resolution.']],album:'cats'},
  {id:'cat-window',board:'cats',title:'Does anyone else’s cat watch an empty window all night?',stamp:'Apr 11 · 11:12 PM',posts:[
   ['DarkDescent','Apr 11 · 11:12 PM','Not chasing reflections. Not looking at birds. Just sitting perfectly still, watching the same second-floor window across the street. For hours.'],
   ['tin_foil_tom','Apr 11 · 11:27 PM','That is standard cat software.'],
   ['DarkDescent','Apr 12 · 12:03 AM','It started at exactly the same time again tonight. I wrote it down.']]},
  {id:'harbor-shape',board:'harbor',title:'[SIGHTING] Something on two legs behind the loading sheds',stamp:'Feb 12 · 12:24 AM',posts:[
   ['DarkDescent','Feb 12 · 12:24 AM','Witness says it was too tall for a dog and too fast for a person. Harbor side. Camera caught three frames. All three look like a wet coat falling down stairs.'],
   ['skeptic42','Feb 12 · 12:39 AM','Or a person in a wet coat falling down stairs.'],
   ['DarkDescent','Feb 12 · 12:47 AM','A valuable competing hypothesis. I have added it to the folder.']],album:'harbor'},
  {id:'dock-footprints',board:'harbor',title:'Large footprints / small explanation',stamp:'Mar 10 · 6:55 AM',posts:[
   ['DarkDescent','Mar 10 · 6:55 AM','Prints in the mud near the water. Four toes? Five? Hard to tell. Uploading the photos before someone drives through them.'],
   ['lakewatcher','Mar 10 · 7:12 AM','Can you put something next to them for scale?'],
   ['DarkDescent','Mar 10 · 7:36 AM','I used a boot. Now everyone says they are boot prints. This is why evidence gathering is difficult.']],album:'harbor'},
  {id:'lake-lights',board:'sky',title:'Three lights over the lake — anyone else awake?',stamp:'Jan 11 · 2:16 AM',posts:[
   ['DarkDescent','Jan 11 · 2:16 AM','Triangle formation. No sound. Moved together until one went dark. My camera mostly photographed the inside of my window.'],
   ['skeptic42','Jan 11 · 2:28 AM','Have you eliminated boats?'],
   ['DarkDescent','Jan 11 · 2:41 AM','Yes. Have not eliminated very ambitious boats.']],album:'ufo'},
  {id:'nessie',board:'sky',title:'Loch Ness archive — NOT Lake Superior, please read',stamp:'Mar 12 · 7:02 PM',posts:[
   ['DarkDescent','Mar 12 · 7:02 PM','Moving the older lake-monster scans here. Loch Ness. Scotland. Not the thing somebody saw next to a buoy last Thursday.'],
   ['tin_foil_tom','Mar 12 · 7:26 PM','Your folder still says LOCK NESS.'],
   ['DarkDescent','Mar 12 · 7:40 PM','The folder name is part of the historical record and will not be corrected.']],album:'nessie'},
  {id:'welcome-vampires',board:'vampires',title:'READ FIRST: folklore is not the same as a tested method',stamp:'May 12 · 10:08 PM',pinned:true,posts:[
   ['DarkDescent','May 12 · 10:08 PM','We do not have a reliable checklist. Mirrors, garlic, running water: a lot of stories contradict each other. Do not approach anyone to “test” them. Get home safely. Write down what you actually saw.'],
   ['lakewatcher','May 12 · 10:32 PM','So what is the point of this board?'],
   ['DarkDescent','May 12 · 10:44 PM','To stop people mistaking certainty for evidence. And to compare the stories that keep repeating.']]},
  {id:'invitation',board:'vampires',title:'The invitation thing. Does a doorway matter?',stamp:'May 11 · 9:45 PM',posts:[
   ['DarkDescent','May 11 · 9:45 PM','Three different accounts mention someone waiting to be asked inside. Coincidence? Manners? Something else? Please separate what happened from what you think it means.'],
   ['dialup_doris','May 11 · 10:01 PM','I also wait to be invited in. My mother raised me properly.'],
   ['DarkDescent','May 11 · 10:14 PM','Noted. You remain on the list of normal explanations.']]},
  {id:'missing-reflections',board:'vampires',title:'Cameras, reflections, and convenient equipment failures',stamp:'May 10 · 11:18 PM',posts:[
   ['DarkDescent','May 10 · 11:18 PM','I am collecting accounts of photographs that failed at exactly the wrong moment. Not every corrupted file is a conspiracy. But keep the original if you have it.'],
   ['skeptic42','May 10 · 11:33 PM','Every photograph on your website has failed.'],
   ['DarkDescent','May 10 · 11:48 PM','An observation I regret to confirm.']]},
  {id:'six-months',board:'patterns',title:'Index housekeeping: new folders, same old questions',stamp:'May 12 · 8:14 PM',posts:[
   ['DarkDescent','May 12 · 8:14 PM','The older lights-in-the-sky and lake-monster albums are still here. Recent material has its own index now. Please do not dump night-sighting accounts into the UFO folder just because you cannot explain them.'],
   ['tin_foil_tom','May 12 · 8:30 PM','You used to post about flying saucers every day.'],
   ['DarkDescent','May 12 · 8:52 PM','Sometimes the interesting question is closer to the ground.']]},
  {id:'mirror-return',board:'patterns',title:'Site back online. Please keep local copies.',stamp:'Apr 11 · 4:07 AM',posts:[
   ['DarkDescent','Apr 11 · 4:07 AM','If you found an empty page earlier, the current mirror is back. Your bookmarks should work. Some attachments are still missing.'],
   ['mothman_mom','Apr 11 · 7:44 AM','Did you break it again?'],
   ['DarkDescent','Apr 11 · 8:03 AM','The cat has been cleared of wrongdoing. That is all I am saying for now.']]},
  {id:'march-archive',board:'patterns',title:'Archive note: March sightings moved',stamp:'Mar 18 · 10:22 PM',posts:[
   ['DarkDescent','Mar 18 · 10:22 PM','Reorganizing a few things. Sky photographs stay in Sky. Accounts of people who only appear after dark will be collected separately. It is probably nothing, but the dates are worth comparing.'],
   ['lakewatcher','Mar 18 · 10:37 PM','You say “probably nothing” a lot lately.'],
   ['DarkDescent','Mar 18 · 10:51 PM','It is a working title.']]}],
 albums:[
  {id:'cats',title:'Highly classified cat photographs',files:['cat_final_FINAL2.gif','modem_guardian.jpg','DO_NOT_DELETE_cat.bmp']},
  {id:'harbor',title:'Harbor sightings / please enhance',files:['dock_shape_01.jpg','dock_shape_02.jpg','footprint_WITH_BOOT.jpg']},
  {id:'ufo',title:'Objects which remain unidentified',files:['triangle_lights.jpg','window_reflection_maybe.jpg','sky_scan_004.gif']},
  {id:'nessie',title:'The LOCK NESS collection',files:['nessie_scan_1997.gif','wake_or_neck.jpg','very_convincing_blob.bmp']}]
};
Object.assign(window.VERUM_FORUM,{
 members:{
  DarkDescent:{title:'Webmaster / Senior Investigator',joined:'1997',location:'The northern hemisphere. Nice try.',bio:'Collector of patterns, damaged image files, and opinions nobody requested. The cat is not an administrator, despite several successful attempts to sit on the keyboard.',signature:'The truth is out there. The cat is in here. Please close the door.'},
  dialup_doris:{title:'Esteemed Regular',joined:'1998',location:'Near an outlet',bio:'Here for recipes and cat pictures. Has accidentally become the forum’s primary source of emotional stability.',signature:'Sent from the family computer. If this posts twice, it was the cat.'},
  hotdish_hank:{title:'Casserole Correspondent',joined:'1999',location:'Within reasonable driving distance of a potluck',bio:'Would appreciate fewer supernatural explanations for ordinary leftovers. Owns the forum’s only clearly labeled freezer.',signature:'A covered dish is a love language. Please return the dish.'},
  mothman_mom:{title:'Night Shift Regular',joined:'1999',location:'Kitchen table',bio:'Likes cats, moths, and making sure everyone brought a jacket. Does not endorse whatever is currently happening in the harbor board.',signature:'Have you eaten? Have you hydrated? Have you checked under the car for a cat?'},
  tin_foil_tom:{title:'Signal Enthusiast',joined:'1998',location:'Reception varies',bio:'Retired three times from this website. Still posts every night. Lists his cat as a dependent on forms that do not ask.',signature:'Please stop quoting my signature as evidence.'},
  skeptic42:{title:'Resident Wet Blanket',joined:'2000',location:'A place with adequate lighting',bio:'Would like everyone to photograph the subject rather than the inside of their pocket. Stayed for the cat board. Denies this.',signature:'Extraordinary claims require a second photo with the lens cap off.'},
  lakewatcher:{title:'Harbor Correspondent',joined:'2000',location:'By the lake',bio:'Keeps a notebook. Carries spare batteries. Has never managed to have both at the same time.',signature:'A blurry photo is still technically a photo.'}
 }
});
window.VERUM_FORUM.threads.push(
 {id:'cat-lawyer',board:'cats',title:'My cat needs a lawyer (minor printer incident)',stamp:'Apr 12 · 7:18 PM',posts:[
  ['DarkDescent','Apr 12 · 7:18 PM','She printed forty-six pages containing only the letter j. I did not know the printer still worked. We are treating this as a statement, not a confession.'],
  ['dialup_doris','Apr 12 · 7:29 PM','Was she standing on the keyboard?'],
  ['DarkDescent','Apr 12 · 7:35 PM','My client has been advised not to answer.'],
  ['skeptic42','Apr 12 · 7:52 PM','I can represent her. My fee is one clear photo of literally anything.']]},
 {id:'cat-ranking',board:'cats',title:'[POLL RESULTS] Which cat could best operate a lighthouse?',stamp:'Mar 11 · 6:02 PM',posts:[
  ['mothman_mom','Mar 11 · 6:02 PM','Voting closed. Mr. Business received 12 votes. My neighbor’s cat received 4. “A qualified adult” received 0. Thank you for participating responsibly.'],
  ['DarkDescent','Mar 11 · 6:18 PM','Mr. Business has the required maritime temperament. He has been staring at a fish stick for six minutes.'],
  ['hotdish_hank','Mar 11 · 6:42 PM','That fish stick is mine.'],
  ['DarkDescent','Mar 11 · 7:01 PM','Please take ownership disputes to the dinner board.']]},
 {id:'cat-hat',board:'cats',title:'UPDATE: he has removed the tiny investigator hat',stamp:'Feb 10 · 9:11 PM',posts:[
  ['DarkDescent','Feb 10 · 9:11 PM','The hat lasted eleven seconds. For six of those seconds he looked extremely qualified. Photograph attached, in spirit.'],
  ['tin_foil_tom','Feb 10 · 9:24 PM','Mine refuses hats but tolerates a badge.'],
  ['DarkDescent','Feb 10 · 9:38 PM','Please tell me you did not give your cat actual jurisdiction.']],album:'cats'},
 {id:'cat-incident',board:'patterns',title:'Please stop connecting the cat’s behavior to the missing photographs',stamp:'Apr 12 · 6:40 PM',posts:[
  ['DarkDescent','Apr 12 · 6:40 PM','The cat has no known connection to the recent image losses. She has a very full schedule of sleeping in a box and moving one pencil off the desk.'],
  ['tin_foil_tom','Apr 12 · 6:58 PM','Has the pencil been recovered?'],
  ['DarkDescent','Apr 12 · 7:04 PM','No. Please do not start a separate thread.']]},
 {id:'brown-bag',board:'vampires',title:'Could a vampire have a normal cat?',stamp:'May 12 · 5:03 PM',posts:[
  ['DarkDescent','May 12 · 5:03 PM','A serious question. People keep describing cats as if they are reliable witnesses. I have observed mine walk directly into a paper bag and express outrage at its existence.'],
  ['mothman_mom','May 12 · 5:17 PM','A cat is allowed one personal mystery.'],
  ['DarkDescent','May 12 · 5:26 PM','I think she has more than one.'],
  ['dialup_doris','May 12 · 5:41 PM','I would still like to see the bag pictures.']],album:'cats'}
);
window.VERUM_FORUM.threads.push(
 {id:'twig-after-dark',board:'vampires',title:'Twig after dark: anyone else keeping notes?',stamp:'May 12 · 10:51 PM',posts:[
  ['DarkDescent','May 12 · 10:51 PM','A few trips through Twig lately. Same small group, same general hours. I am not posting a location. I would rather compare observations before everyone starts writing a screenplay in the replies.'],
  ['lakewatcher','May 12 · 11:06 PM','You mean the people from your last post?'],
  ['DarkDescent','May 12 · 11:17 PM','I mean there is a difference between a late night and a way of life. These people are very committed to the latter.'],
  ['skeptic42','May 12 · 11:29 PM','So are the people on this website.'],
  ['DarkDescent','May 12 · 11:42 PM','Yes. Some of us still make an appearance before sundown. Occasionally. For cat food.']]},
 {id:'twig-routine',board:'patterns',title:'The west-side notes: a routine is a kind of signature',stamp:'May 11 · 11:51 PM',posts:[
  ['DarkDescent','May 11 · 11:51 PM','The Twig folder is getting less random. Different nights, a familiar little clutch. They seem comfortable enough to repeat themselves. Comfort makes people careless.'],
  ['tin_foil_tom','May 12 · 12:06 AM','I thought we agreed to stop saying clutch. It makes them sound like handbags.'],
  ['DarkDescent','May 12 · 12:14 AM','Fine. A gathering of people who may have rather specific dietary preferences. The spreadsheet does not care what we call them.'],
  ['mothman_mom','May 12 · 12:28 AM','Please tell me you are not sitting in your car outside someone’s house.'],
  ['DarkDescent','May 12 · 12:39 AM','I am home. The cat has confiscated my coat.']]},
 {id:'observation-enough',board:'vampires',title:'At what point is observation just permission?',stamp:'May 12 · 11:46 PM',posts:[
  ['DarkDescent','May 12 · 11:46 PM','We keep collecting the same accounts. We keep asking for one better photograph. Meanwhile the small group out near Twig gets another quiet night. I am beginning to think another folder is not the answer.'],
  ['dialup_doris','May 12 · 11:51 PM','This sounds like the beginning of a very poor decision.'],
  ['DarkDescent','May 12 · 11:57 PM','Doing nothing is also a decision. I have been exceptionally well behaved about this for months.'],
  ['lakewatcher','May 13 · 12:04 AM','What exactly are you suggesting?'],
  ['DarkDescent','May 13 · 12:13 AM','That comfortable routines can be interrupted. That is all I am putting on a public board.'],
  ['mothman_mom','May 13 · 12:26 AM','Put the kettle on. Feed the cat. Sleep before you decide anything.'],
  ['DarkDescent','May 13 · 12:38 AM','The cat has been fed. Thank you for your concern.']]}
);
window.VERUM_FORUM.threads.push(
 {id:'darkdescent-check-in',board:'patterns',title:'Has anyone actually heard from DarkDescent?',stamp:'Jul 20 · 8:46 PM',posts:[
  ['dialup_doris','Jul 20 · 8:46 PM','Two months without an unsolicited update on the cat feels excessive. He has not answered my messages. Does anyone know him outside this board?'],
  ['tin_foil_tom','Jul 20 · 9:12 PM','He sometimes moves mirrors. Maybe we are all on the wrong one.'],
  ['lakewatcher','Jul 20 · 9:37 PM','He said he would post after the Twig thing. I do not see anything after that.'],
  ['mothman_mom','Jul 20 · 10:03 PM','Please do not go looking for him just because he went looking for someone else. I would like fewer people missing from this conversation.']]},
 {id:'cat-whereabouts',board:'cats',title:'This is technically still a cat question',stamp:'Aug 27 · 6:21 PM',posts:[
  ['mothman_mom','Aug 27 · 6:21 PM','If anyone has a way to contact DarkDescent, can you at least ask whether the cat is all right? I know that is not the biggest question. It is the one I know how to ask.'],
  ['hotdish_hank','Aug 27 · 6:44 PM','I keep expecting him to come back and tell us the cat has retained counsel.'],
  ['dialup_doris','Aug 27 · 7:08 PM','I would happily endure another printer thread.'],
  ['skeptic42','Aug 27 · 7:39 PM','Same. For the record, I never thought the photographs were that bad.']]},
 {id:'mirror-still-here',board:'patterns',title:'The site is still here. That is not quite the same thing.',stamp:'Sep 4 · 11:02 PM',posts:[
  ['lakewatcher','Sep 4 · 11:02 PM','People keep saying the page is online, so he must be fine. A page can sit here for a long time without anybody touching it. His last reply is still the one about feeding the cat.'],
  ['tin_foil_tom','Sep 4 · 11:18 PM','Maybe he finally decided to log off. Not everything has to mean the worst possible thing.'],
  ['dialup_doris','Sep 4 · 11:31 PM','Maybe. I would like to hear that from him.'],
  ['mothman_mom','Sep 4 · 11:47 PM','Leaving this here in case he comes back: you do not owe us an explanation. A full stop would do. Anything, really.']]}
);
window.VERUM_FORUM.threads.push(
 {id:'june-dinner',board:'dinner',title:'Dinner thread, if anyone is still doing these',stamp:'Jun 3 · 7:16 PM',posts:[
  ['hotdish_hank','Jun 3 · 7:16 PM','Baked potato. Butter. Quiet house. I made two out of habit.'],
  ['dialup_doris','Jun 3 · 8:04 PM','Toast here. Please consider this a formal invitation to describe the butter.'],
  ['hotdish_hank','Jun 4 · 7:12 PM','Salted. Thank you for asking.']]},
 {id:'june-cat-desk',board:'cats',title:'She has promoted herself to desk supervisor',stamp:'Jun 8 · 9:02 PM',posts:[
  ['mothman_mom','Jun 8 · 9:02 PM','No photo because the upload form is still having feelings. Imagine a very small manager with absolutely no respect for the timesheet.'],
  ['tin_foil_tom','Jun 9 · 12:17 AM','Mine sleeps on the mouse. Productivity is down but morale is complicated.'],
  ['dialup_doris','Jun 10 · 6:22 PM','At least somebody is keeping office hours.']]},
 {id:'june-light',board:'sky',title:'One light over the lake. Probably one ordinary light.',stamp:'Jun 21 · 10:13 PM',posts:[
  ['lakewatcher','Jun 21 · 10:13 PM','Saw it from the shore. It moved slowly and eventually went away. I suppose this is what a properly cautious report looks like.'],
  ['skeptic42','Jun 23 · 8:49 PM','Perfect. No notes. Weirdly disappointing, but perfect.']]},
 {id:'july-box',board:'cats',title:'The box won again',stamp:'Jul 3 · 5:42 PM',posts:[
  ['dialup_doris','Jul 3 · 5:42 PM','Bought a new cat bed. She is sleeping in the box it came in. Reporting this for the historical record.'],
  ['hotdish_hank','Jul 10 · 9:06 PM','Read this a week ago and meant to reply. A cardboard empire is still an empire.']]},
 {id:'august-tin',board:'dinner',title:'Does anybody remember the biscuit tin argument?',stamp:'Aug 2 · 8:33 PM',posts:[
  ['hotdish_hank','Aug 2 · 8:33 PM','Found it at the back of a cupboard. Biscuits this time, not sewing supplies. Thought someone here would appreciate the distinction. No urgent reply required.']]}
);
