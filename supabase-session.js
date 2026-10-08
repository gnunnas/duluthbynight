// Password sign-in with in-memory tokens: a reload requires signing in again.
// Access decisions are made by Supabase RLS, never by the displayed role label.
(async function(){
 const config=window.SUPABASE_CONFIG,app=document.querySelector('#app');
 const tables=['campaign_status','records','record_names','sections','content_items','relationship_types','relationships','domain_claims','membership_implications','attachments','sources','item_references','selected_powers','power_definitions','route_aliases','review_issues','person_status',...['record_names','content_items','relationships','domain_claims','membership_implications','attachments','power_definitions'].map(x=>x+'_sources')];
 let session=null,refreshTimer=null;
 const headers=()=>({apikey:config.publishableKey,Authorization:'Bearer '+session.access_token,'Content-Type':'application/json'});
 async function auth(path,body,token){
  const response=await fetch(config.url+'/auth/v1/'+path,{method:'POST',headers:{apikey:config.publishableKey,'Content-Type':'application/json',...(token?{Authorization:'Bearer '+token}:{})},body:body?JSON.stringify(body):undefined});
  if(!response.ok)throw Error(path==='token?grant_type=password'?'Sign-in failed. Check your email and password.':'Your session has ended. Sign in again.');
  return response.status===204?null:response.json();
 }
 async function read(table){
  const rows=[];
  for(let offset=0;;offset+=500){
   const query=new URLSearchParams({select:'*',campaign_id:'eq.'+config.campaignId,limit:'500',offset:String(offset),order:table.endsWith('_sources')?'owner_id,source_id':table==='power_definitions'?'power_record_id':table==='route_aliases'?'old_route':table==='campaign_memberships'?'user_id':'id'});
   const response=await fetch(config.url+'/rest/v1/'+table+'?'+query,{headers:headers(),cache:'no-store'});
   if(table==='campaign_status'&&response.status===404)return []; // Status migration may not be installed yet.
   if(!response.ok)throw Error('Could not load campaign data. Check your connection and campaign access.');
   const batch=await response.json();rows.push(...batch);if(batch.length<500)return rows;
  }
 }
 function lock(message){
  clearInterval(refreshTimer);session=null;window.campaignAccess=false;window.CAMPAIGN=null;
  document.querySelector('.ability-dialog')?.remove();
  document.querySelector('.reveal-dialog')?.remove();
  if(window.campaignSession)window.campaignSession.isStoryteller=false;
  app.replaceChildren();const heading=document.createElement('h1');heading.textContent='Session ended';
  const text=document.createElement('p');text.textContent=message;
  const button=document.createElement('button');button.textContent='Sign in again';button.onclick=()=>location.reload();app.append(heading,text,button);
  document.querySelector('#nav').hidden=true;
 }
 async function load(){
  const memberships=await read('campaign_memberships');
  const own=memberships.find(x=>x.user_id===session.user.id&&x.active);
  // Owners have Storyteller access even if there is no membership row.
  const response=await fetch(config.url+'/rest/v1/campaigns?'+new URLSearchParams({select:'owner_user_id',id:'eq.'+config.campaignId}),{headers:headers(),cache:'no-store'});
  if(!response.ok)throw Error('Could not check campaign access.');
  const campaigns=await response.json();const owner=campaigns.some(x=>x.owner_user_id===session.user.id);
  if(!own&&!owner)throw Error('This account does not have active access to this campaign. Ask your Storyteller to add it.');
  const rows=Object.fromEntries(await Promise.all(tables.map(async table=>[table,await read(table)])));
  window.CAMPAIGN=adaptSupabase(rows,config.campaignId);
  createCampaignModel(window.CAMPAIGN); // Validate the projection before showing any records.
  const account=document.querySelector('#account');account.replaceChildren();
  const role=document.createElement('span');role.textContent=owner||own.role==='storyteller'?'Storyteller':'Player';
  const signout=document.createElement('button');signout.textContent='Sign out';signout.onclick=async()=>{
   const token=session.access_token;lock('You have signed out.');
   try{await auth('logout',null,token);}catch{}location.reload();
  };account.append(role,signout);
  window.campaignAccess=true;
  window.campaignSession={isStoryteller:owner||own.role==='storyteller',async saveNote(id,body,revision){
   if(!session)throw Error('Sign in again before saving.');
   const query=new URLSearchParams({campaign_id:'eq.'+config.campaignId,id:'eq.'+id,revision:'eq.'+revision,select:'*'});
   const response=await fetch(config.url+'/rest/v1/content_items?'+query,{method:'PATCH',headers:{...headers(),Prefer:'return=representation'},body:JSON.stringify(window.campaignSession.isStoryteller?{body,knowledge_state:body?'recorded':'unrecorded',origin:'human',approved_proposal_id:null}:{body}),cache:'no-store'});
   if(!response.ok)throw Error('Could not save. Check your connection and editing permissions.');
   const saved=await response.json();if(saved.length!==1)throw Error('This note changed or access was removed. Reload and review the latest version before saving.');
   const stored=rows.content_items.find(x=>x.id===id);if(stored)Object.assign(stored,saved[0]);
   return saved[0];
  }};
  window.campaignSession.editorRows=()=>rows;
  window.campaignSession.editRows=async changes=>{
   if(!session||!window.campaignSession.isStoryteller)throw Error('Storyteller access is required.');
   const response=await fetch(config.url+'/rest/v1/rpc/edit_campaign_rows',{method:'POST',headers:headers(),body:JSON.stringify({p_campaign:config.campaignId,p_changes:changes}),cache:'no-store'});
   if(!response.ok){let detail;try{detail=await response.json();}catch{}const error=Error(['40001','PT409'].includes(detail?.code)?'Another edit was saved first. Reload the latest version; your draft has not been saved.':detail?.code==='PGRST202'?'Apply the new Storyteller editing migration before saving.':'Could not save: '+(detail?.message||'check your connection and permissions.'));error.code=detail?.code;throw error;}
   await response.json();
  };
  window.campaignSession.reloadCampaign=async()=>{
   const fresh=Object.fromEntries(await Promise.all(tables.map(async table=>[table,await read(table)])));
   Object.assign(rows,fresh);return adaptSupabase(rows,config.campaignId);
  };
  window.campaignSession.saveStatus=async(id,changes,revision)=>{
   if(!session||!window.campaignSession.isStoryteller)throw Error('Storyteller access is required.');
   const query=new URLSearchParams({campaign_id:'eq.'+config.campaignId,id:'eq.'+id,revision:'eq.'+revision,select:'*'});
   const response=await fetch(config.url+'/rest/v1/campaign_status?'+query,{method:'PATCH',headers:{...headers(),Prefer:'return=representation'},body:JSON.stringify({label:changes.label,value:changes.value,sort_order:changes.sortOrder,audience:changes.audience,origin:'human'}),cache:'no-store'});
   if(!response.ok)throw Error('Could not save this row. Check your connection and Storyteller permissions.');
   const saved=await response.json();if(saved.length!==1)throw Error('This row changed or access was removed. Reload saved values and review the latest version before saving.');
   const stored=rows.campaign_status.find(x=>x.id===id);if(stored)Object.assign(stored,saved[0]);
   return saved[0];
  };
  window.campaignSession.reloadStatus=async()=>{
   if(!session||!window.campaignSession.isStoryteller)throw Error('Storyteller access is required.');
   return read('campaign_status');
  };
  if(window.campaignSession.isStoryteller){const tools=document.createElement('a');tools.href='#storyteller';tools.textContent='Storyteller';document.querySelector('#nav').append(tools);}
  document.querySelector('#nav').hidden=false;
  await new Promise((resolve,reject)=>{const script=document.createElement('script');script.src='app.js';script.onload=resolve;script.onerror=()=>reject(Error('Could not start the website. Reload to try again.'));document.body.append(script);});
  refreshTimer=setInterval(async()=>{
   if(session.expires_at*1000>Date.now()+90000)return;
   try{const next=await auth('token?grant_type=refresh_token',{refresh_token:session.refresh_token});session={...next,expires_at:next.expires_at||Date.now()/1000+next.expires_in};}
   catch{lock('Your session expired. Reload to sign in again.');}
  },30000);
 }
 app.innerHTML='<section class="login-panel"><h1>Duluth by Night</h1><p>Sign in to your campaign account.</p><form id="signIn"><label>Email<input name="email" type="email" autocomplete="username" required></label><label>Password<input name="password" type="password" autocomplete="current-password" required></label><button type="submit">Sign in</button><p id="authMessage" role="status" aria-live="polite"></p></form></section>';
 document.querySelector('#nav').hidden=true;
 document.querySelector('#signIn').addEventListener('submit',async event=>{
  event.preventDefault();const form=event.currentTarget,button=form.querySelector('button'),message=document.querySelector('#authMessage');
  button.disabled=true;message.textContent='Signing in…';
  try{
   const result=await auth('token?grant_type=password',{email:form.elements.email.value.trim(),password:form.elements.password.value});
   session={...result,expires_at:result.expires_at||Date.now()/1000+result.expires_in};form.elements.password.value='';message.textContent='Loading campaign…';await load();
  }catch(error){session=null;window.CAMPAIGN=null;message.textContent=error.message;button.disabled=false;}
 });
})();
