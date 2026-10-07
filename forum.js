// Public fictional set dressing. No campaign queries, tracking, or simulated access controls.
(function(){
 const F=window.VERUM_FORUM,main=document.querySelector('#forum-main');
 const esc=value=>String(value??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
 const href=(type,id)=>'#forum'+(type?'/'+type:'')+(id?'/'+encodeURIComponent(id):'');
 const anchor=(type,id,text)=>`<a href="${href(type,id)}">${esc(text)}</a>`;
 const member=id=>anchor('member',id,id);
 const boards=F.groups.flatMap(x=>x.boards);
 const board=id=>boards.find(x=>x.id===id);
 const icon={dinner:'▤',cats:'▧',harbor:'☾',sky:'✧',vampires:'†',patterns:'?'};
 function dateKey(stamp){const m=stamp.match(/(\w+) (\d+) · (\d+):(\d+) (AM|PM)/);if(!m)return 0;return ({Jan:1,Feb:2,Mar:3,Apr:4,May:5,Jun:6,Jul:7,Aug:8,Sep:9,Oct:10,Nov:11,Dec:12}[m[1]]||0)*100000+Number(m[2])*1440+(Number(m[3])%12+(m[5]==='PM'?12:0))*60+Number(m[4]);}
 const latest=threads=>[...threads].sort((a,b)=>dateKey(b.posts.at(-1)[1])-dateKey(a.posts.at(-1)[1]));
 const broken=(file)=>`<div class="gif" role="img" aria-label="Image cannot be displayed: ${esc(file)}"><span class="brokenicon" aria-hidden="true">▧</span><span>Image cannot<br>be displayed</span></div>`;
 const crumb=(html='Forum Index')=>`<p class="crumb">${anchor('','','Verumdetenebris')} » ${html}</p>`;
 const bar=title=>`<h2 class="bar">${esc(title)}</h2>`;
 function boardRow(b){const t=latest(F.threads.filter(x=>x.board===b.id))[0],p=t.posts.at(-1);return `<tr><td class="icon" aria-hidden="true">${icon[b.id]}</td><td>${anchor('board',b.id,b.name).replace('<a ','<a class="board-title" ')}<div class="desc">${esc(b.description)}</div></td><td class="last">${anchor('thread',t.id,t.title)}<br>${member(p[0])} · ${esc(p[1])}<br><span class="new">[ NEW TRANSMISSION ]</span></td></tr>`;}
 function threadRows(threads){return `<table class="table"><thead><tr><th>Subject</th><th class="reply-count">Replies</th><th class="last">Last transmission</th></tr></thead><tbody>${latest(threads).map(t=>{const p=t.posts.at(-1);return `<tr><td>${t.pinned?'<span class="new">[ PINNED ]</span><br>':''}${anchor('thread',t.id,t.title).replace('<a ','<a class="board-title" ')}<div class="desc">Started by ${member(t.posts[0][0])} · ${anchor('board',t.board,board(t.board).name)}</div></td><td class="reply-count">${t.posts.length-1}</td><td class="last">${member(p[0])}<br>${esc(p[1])}</td></tr>`;}).join('')}</tbody></table>`;}
 function index(){const newest=latest(F.threads)[0].posts.at(-1);return crumb()+bar(':: TRANSMISSIONS FROM THE EDGE ::')+`<div class="notice"><b>Welcome, anonymous traveler.</b><br>Leave your certainty at the door. The cat photos are down again.<br>Latest transmission: ${esc(newest[1])} · ${member(newest[0])}</div>`+F.groups.map(g=>bar(g.name)+`<table class="table"><thead><tr><th colspan="2">Forum / description</th><th class="last">Last transmission</th></tr></thead><tbody>${g.boards.map(boardRow).join('')}</tbody></table>`).join('')+bar('LATEST TRANSMISSIONS')+`<div class="recent">${latest(F.threads).slice(0,3).map(t=>`<p>» ${anchor('thread',t.id,t.title)}<br><small>${member(t.posts.at(-1)[0])} · ${esc(t.posts.at(-1)[1])}</small></p>`).join('')}</div>`;}
 function conversation(t){return crumb(`${anchor('board',t.board,board(t.board).name)} » Thread`)+bar(t.title)+`<div class="thread-tools">${anchor('board',t.board,'« Return to board')} <span>${t.posts.length} transmissions · guest view</span></div>`+t.posts.map(([user,stamp,text],i)=>`<article class="post"><aside class="poster">${member(user)}<p>${esc(F.members[user].title)}</p>${broken(user+'_avatar.gif')}<p>Member since ${esc(F.members[user].joined)}</p></aside><div class="post-body"><div class="post-stamp">${esc(stamp)} · transmission #${i+1}</div><div>${esc(text)}</div>${i===0&&t.album?`<p>Attachment folder: ${anchor('album',t.album,F.albums.find(a=>a.id===t.album).title)}</p>`:''}<div class="signature">${esc(F.members[user].signature)}</div></div></article>`).join('')+`<p class="posting-note">You are browsing as a guest. This mirror preserves the conversation; replies are closed.</p><div class="thread-tools">${anchor('board',t.board,'« Back to the board')}${anchor('recent','','More transmissions »')}</div>`;}
 function album(a){return crumb(`${anchor('albums','','Photo evidence')} » ${esc(a.title)}`)+bar(a.title)+`<div class="notice">Uploaded by ${member('DarkDescent')}.<br>Please allow up to several minutes, or until your faith runs out, for the images to load.</div><div class="album-grid">${a.files.map((file,i)=>`<div>${anchor('photo',a.id+':'+i,'Open image '+(i+1)).replace('</a>',broken(file)+'</a>')}<p class="file-caption">${esc(file)}</p></div>`).join('')}</div><div class="thread-tools">${anchor('albums','','« All evidence folders')}${anchor('thread',F.threads.find(t=>t.album===a.id)?.id||'missing-reflections','Discuss this evidence »')}</div>`;}
 function profile(id){const p=F.members[id];return crumb('Member directory')+bar(id)+`<div class="body-copy"><div class="profile-facts">${broken(id+'_avatar.gif')}<b>${esc(p.title)}</b><br>Member since: ${esc(p.joined)}<br>Location: ${esc(p.location)}</div><p>${esc(p.bio)}</p><div class="signature">${esc(p.signature)}</div></div>`+bar('THREADS THIS MEMBER HAS POSTED IN')+threadRows(F.threads.filter(t=>t.posts.some(x=>x[0]===id)));}
 function about(){return crumb('About this place')+bar('ABOUT VERUMDETENEBRIS')+`<div class="body-copy"><h3>Truth out of darkness.</h3><p>A place for the things you saw and the people who will ask whether you checked the batteries. Lights over the lake. Strange figures by the docks. Dinner. Cats.</p><p>The forum is maintained by ${member('DarkDescent')}. Everyone is welcome to read. Nobody is required to agree. Please distinguish “I saw it” from “my cousin’s coworker knew a guy.”</p><h3>Community standards</h3><p>Be civil. Label your blurry photographs. Do not post anyone’s address. Cat photographs belong in ${anchor('board','cats','the cat board')}, unless the cat is visibly operating a spacecraft. In that case, use both boards.</p><p>We do not sell garlic kits, crystal subscriptions, or certificates proving your cat is a licensed medium. Please stop asking.</p><h3>Technical notes</h3><p>Attachments may fail. The webmaster is aware. An investigation has been opened into why he keeps naming files FINAL when they are not final.</p><p>Explore the ${anchor('webring','','Strange North Webring')} or start at the ${anchor('','','forum index')}.</p></div>`;}
 function webring(){return crumb('Strange North Webring')+bar('STRANGE NORTH WEBRING')+`<div class="body-copy"><p>Neighbors on the information superhighway. None of these sites agree on anything except cats.</p><ul><li>${anchor('member','tin_foil_tom','Tom’s Signal Shack')} — foil craftsmanship and reception diaries.</li><li>${anchor('album','nessie','The LOCK NESS Files')} — spelling disputed, conviction unwavering.</li><li>${anchor('member','hotdish_hank','The Covered Dish Zone')} — mysteries that can be reheated.</li><li>${anchor('board','cats','The Cat Astral Society')} — meetings postponed until everyone wakes up.</li></ul><p>This ring is maintained by ${member('DarkDescent')}. If a neighbor’s page is down, please do not blame the moon until you have ruled out their modem.</p></div>`;}
 function render(focus=false){
  const raw=location.hash.slice(1)||'forum';
  // Preserve existing campaign bookmarks. All new forum routes use their own prefix.
  if(/^(home|people|places|threads|chronicle|organizations|clans|disciplines|powers|notes|search|groups|factions|schemes|events)([/?]|$)/.test(raw)){location.replace('campaign.html#'+raw);return;}
  if(raw==='forum-main'){if(!main.children.length)main.innerHTML=index();main.focus();return;}
  let parts;try{parts=raw.split('/').map(decodeURIComponent);}catch{parts=[];}
  const [,type='',id]=parts;let html,title='Forum Index';
  if(parts[0]==='forum'&&parts.length<=3){
   if(!type)html=index();
   else if(type==='board'&&board(id)){title=board(id).name;html=crumb(title)+bar(title)+`<div class="notice">${esc(board(id).description)}</div>`+threadRows(F.threads.filter(t=>t.board===id));}
   else if(type==='thread'&&F.threads.some(t=>t.id===id)){const t=F.threads.find(t=>t.id===id);title=t.title;html=conversation(t);}
   else if(type==='recent'&&!id){title='Latest transmissions';html=crumb(title)+bar(title)+threadRows(F.threads);}
   else if(type==='albums'&&!id){title='Photo evidence';html=crumb(title)+bar(title)+`<div class="body-copy">${F.albums.map(a=>`<p>${anchor('album',a.id,a.title)} — ${a.files.length} alleged photographs</p>`).join('')}</div>`;}
   else if(type==='album'&&F.albums.some(a=>a.id===id)){const a=F.albums.find(a=>a.id===id);title=a.title;html=album(a);}
   else if(type==='photo'){
    const [albumId,n]=String(id).split(':'),a=F.albums.find(a=>a.id===albumId),file=a?.files[Number(n)];
    if(file){title=file;html=crumb(anchor('album',a.id,a.title))+bar(file)+`<div class="body-copy">${broken(file)}<p>Image cannot be displayed.</p><p>This attachment appears to have suffered an unexplained technical indignity. The filename has survived.</p><p>${anchor('album',a.id,'« Return to the evidence folder')}</p></div>`;}
   }
   else if(type==='member'&&Object.hasOwn(F.members,id)){title=id;html=profile(id);}
   else if(type==='about'&&!id){title='About this place';html=about();}
   else if(type==='webring'&&!id){title='Strange North Webring';html=webring();}
  }
  if(!html){title='Transmission not found';html=crumb(title)+bar(title)+`<div class="body-copy"><p>This transmission is missing. The cat has declined to comment.</p><p>${anchor('','','Return to the forum index')}</p></div>`;}
  main.innerHTML=html;document.title=title+' :: Verumdetenebris';
  if(focus){main.focus({preventScroll:true});window.scrollTo(0,0);}
 }
 window.addEventListener('hashchange',()=>render(true));render();
})();
