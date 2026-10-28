// Password sign-in with in-memory tokens: a reload requires signing in again.
// Access decisions are made by Supabase RLS, never by the displayed role label.
(async function(){
 const config=window.SUPABASE_CONFIG,app=document.querySelector('#app');
 // Carry the HTML release version through the script loaded after signing in.
 const appVersion=new URL(document.currentScript.src).searchParams.get('v');
 let session=null,refreshTimer=null,loader=null;
 const headers=()=>({apikey:config.publishableKey,Authorization:'Bearer '+session.access_token,'Content-Type':'application/json'});
 async function auth(path,body,token){
  const response=await fetch(config.url+'/auth/v1/'+path,{method:'POST',headers:{apikey:config.publishableKey,'Content-Type':'application/json',...(token?{Authorization:'Bearer '+token}:{})},body:body?JSON.stringify(body):undefined});
  if(!response.ok){
   if(path==='token?grant_type=password')throw Error('Sign-in failed. Check your email and password.');
   if(path.startsWith('signup'))throw Error(response.status===429?'Too many signup attempts. Wait a few minutes and try again.':'Could not create the account. Check the email and use a password with at least 8 characters.');
   throw Error('Your session has ended. Sign in again.');
  }
  return response.status===204?null:response.json();
 }
 async function rpc(name,body){
  const response=await fetch(config.url+'/rest/v1/rpc/'+name,{method:'POST',headers:headers(),body:JSON.stringify(body),cache:'no-store'});
  if(!response.ok){let detail;try{detail=await response.json();}catch{}const error=Error(detail?.code==='PGRST202'?'The player signup database update has not been installed yet.':detail?.message||'The request could not be completed.');error.code=detail?.code;throw error;}
  return response.status===204?null:response.json();
 }
 async function read(table,expectedSession=session,filters={}){
  const rows=[];
  for(let offset=0;;offset+=500){
   if(session!==expectedSession)throw Error('Campaign session changed.');
   const query=new URLSearchParams({select:'*',campaign_id:'eq.'+config.campaignId,limit:'500',offset:String(offset),order:table.endsWith('_sources')?'owner_id,source_id':table==='power_definitions'?'power_record_id':table==='route_aliases'?'old_route':table==='campaign_memberships'?'user_id':'id'});
   for(const [key,value]of Object.entries(filters))query.set(key,value);
   const response=await fetch(config.url+'/rest/v1/'+table+'?'+query,{headers:headers(),cache:'no-store'});
   if(table==='campaign_status'&&response.status===404)return []; // Status migration may not be installed yet.
   if(!response.ok)throw Error('Could not load campaign data. Check your connection and campaign access.');
   const batch=await response.json();rows.push(...batch);if(batch.length<500)return rows;
  }
 }
 function lock(message){
  clearInterval(refreshTimer);loader?.clear();window.CampaignEditor?.clear();session=null;window.campaignAccess=false;window.CAMPAIGN=null;
  document.querySelector('.ability-dialog')?.remove();
  document.querySelector('.reveal-dialog')?.remove();
  if(window.campaignSession)window.campaignSession.isStoryteller=false;
  app.replaceChildren();const heading=document.createElement('h1');heading.textContent='Session ended';
  const text=document.createElement('p');text.textContent=message;
  const button=document.createElement('button');button.textContent='Sign in again';button.onclick=()=>location.reload();app.append(heading,text,button);
  document.querySelector('#nav').hidden=true;
 }
 function startRefresh(){
  clearInterval(refreshTimer);refreshTimer=setInterval(async()=>{
   if(!session||session.expires_at*1000>Date.now()+90000)return;
   try{const next=await auth('token?grant_type=refresh_token',{refresh_token:session.refresh_token});session={...next,expires_at:next.expires_at||Date.now()/1000+next.expires_in};}
   catch{lock('Your session expired. Reload to sign in again.');}
  },30000);
 }
 function signOutControl(){
  const button=document.createElement('button');button.textContent='Sign out';button.onclick=async()=>{
   const token=session?.access_token;lock('You have signed out.');
   try{if(token)await auth('logout',null,token);}catch{}location.reload();
  };return button;
 }
 async function showAccessRequest(){
  loader?.clear();window.CampaignEditor?.clear();window.campaignAccess=false;window.CAMPAIGN=null;
  document.querySelector('#nav').hidden=true;
  const account=document.querySelector('#account');account.replaceChildren(signOutControl());
  app.innerHTML='<section class="login-panel access-request-panel"><h1>Campaign access</h1><p id="accessRequestText" role="status" aria-live="polite">Checking your request…</p><button id="requestAccess" type="button" hidden>Request player access</button><p class="auth-help">Your Storyteller must approve the request before campaign information becomes available.</p></section>';
  const text=document.querySelector('#accessRequestText'),button=document.querySelector('#requestAccess');
  try{
   const status=await rpc('campaign_access_request_status',{p_campaign:config.campaignId});
   if(status==='pending')text.textContent='Your request is waiting for Storyteller approval.';
   else if(status==='rejected'){text.textContent='Your previous request was not approved. You can send a new request if that was a mistake.';button.hidden=false;}
   else if(status==='approved')text.textContent='Your access was approved. Sign out and sign in again to load the campaign.';
   else{text.textContent='This account does not have access to Duluth by Night yet.';button.hidden=false;}
   button.onclick=async()=>{button.disabled=true;text.textContent='Sending request…';try{await rpc('request_campaign_access',{p_campaign:config.campaignId});text.textContent='Request sent. Your Storyteller can now approve it.';button.hidden=true;}catch(error){text.textContent=error.message;button.disabled=false;}};
  }catch(error){text.textContent=error.message;}
  startRefresh();
 }
 async function load(){
  const [memberships,response]=await Promise.all([
   read('campaign_memberships'),
   fetch(config.url+'/rest/v1/campaigns?'+new URLSearchParams({select:'owner_user_id',id:'eq.'+config.campaignId}),{headers:headers(),cache:'no-store'})
  ]);
  const own=memberships.find(x=>x.user_id===session.user.id&&x.active);
  // Owners have Storyteller access even if there is no membership row.
  if(!response.ok)throw Error('Could not check campaign access.');
  const campaigns=await response.json();const owner=campaigns.some(x=>x.owner_user_id===session.user.id);
  if(!own&&!owner){await showAccessRequest();return;}
  loader=createCampaignLoader(async function requestPage(name,payload){
   if(name==='load_campaign_page'&&payload.p_scope==='record-editor'){
    // Ordinary editing needs this record, not every campaign field or provenance link.
    const expectedSession=session,isArchive=loader.rows.records?.some(row=>row.id===payload.p_record&&row.record_type==='note');
    const [detail,sources]=await Promise.all([
     requestPage(name,{...payload,p_scope:'detail'}),
     isArchive?read('sources',expectedSession,{note_record_id:'eq.'+payload.p_record}):Promise.resolve([])
    ]);
    if(session!==expectedSession)throw Error('Campaign session changed.');
    return {...detail,sources};
   }
   if(name==='load_campaign_page'&&payload.p_scope==='editor'){
    // Keep the full editor graph, but avoid one oversized SQL/RLS statement.
    const tables=['campaign_status','records','record_names','sections','content_items','relationship_types','relationships','domain_claims','membership_implications','attachments','sources','item_references','selected_powers','power_definitions','route_aliases','review_issues','person_status','record_names_sources','content_items_sources','relationships_sources','domain_claims_sources','membership_implications_sources','attachments_sources','power_definitions_sources'];
    const result={},expectedSession=session;let next=0,failed=false;
    async function worker(){try{while(!failed&&next<tables.length){if(session!==expectedSession)throw Error('Campaign session changed.');const table=tables[next++];result[table]=await read(table,expectedSession);}}catch(error){failed=true;throw error;}}
    await Promise.all([worker(),worker(),worker()]);return result;
   }
   const response=await fetch(config.url+'/rest/v1/rpc/'+name,{method:'POST',headers:headers(),body:JSON.stringify(payload),cache:'no-store'});
   if(!response.ok){let detail;try{detail=await response.json();}catch{}throw Error(detail?.code==='PGRST202'?'Apply migration 010 (campaign lazy loading) in Supabase before using this website.':'Could not load this campaign page. Check your connection and access.');}
   return response.json();
  },config.campaignId);
  window.CAMPAIGN=await loader.catalog();
  const rows=loader.rows;
  createCampaignModel(window.CAMPAIGN); // Validate the projection before showing any records.
  const account=document.querySelector('#account');account.replaceChildren();
  const role=document.createElement('span');role.textContent=owner||own.role==='storyteller'?'Storyteller':'Player';
  account.append(role,signOutControl());
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
  window.campaignSession.loadRevealData=async()=>{
   if(!session||!window.campaignSession.isStoryteller)throw Error('Storyteller access is required.');
   await loader.reviewData();
   if(validateCampaign(loader.project()).length)throw Error('Campaign dependencies changed. Reload saved entries before reviewing again.');
  };
  window.campaignSession.editRows=async changes=>{
   if(!session||!window.campaignSession.isStoryteller)throw Error('Storyteller access is required.');
   const response=await fetch(config.url+'/rest/v1/rpc/edit_campaign_rows',{method:'POST',headers:headers(),body:JSON.stringify({p_campaign:config.campaignId,p_changes:changes}),cache:'no-store'});
   if(!response.ok){let detail;try{detail=await response.json();}catch{}const error=Error(['40001','PT409'].includes(detail?.code)?'Another edit was saved first. Reload the latest version; your draft has not been saved.':detail?.code==='PGRST202'?'Apply the new Storyteller editing migration before saving.':'Could not save: '+(detail?.message||'check your connection and permissions.'));error.code=detail?.code;throw error;}
   await response.json();
  };
  window.campaignSession.saveSummary=async(recordId,revision,body)=>{
   if(!session||!window.campaignSession.isStoryteller)throw Error('Storyteller access required.');
   const response=await fetch(config.url+'/rest/v1/rpc/save_record_summary',{method:'POST',headers:headers(),body:JSON.stringify({p_campaign:config.campaignId,p_record:recordId,p_revision:revision,p_body:body}),cache:'no-store'});
   if(!response.ok){let detail;try{detail=await response.json();}catch{}const error=Error(detail?.code==='40001'?'Another edit was saved first. Your draft is retained; copy it before reloading.':detail?.code==='PGRST202'?'Apply migration 013 for summary editing before saving.':detail?.message||'Could not save this summary.');error.code=detail?.code;throw error;}
   return response.json();
  };
  window.campaignSession.saveOrganizationType=async(recordId,revision,type)=>{
   if(!session||!window.campaignSession.isStoryteller)throw Error('Storyteller access required.');
   const response=await fetch(config.url+'/rest/v1/rpc/save_organization_type',{method:'POST',headers:headers(),body:JSON.stringify({p_campaign:config.campaignId,p_record:recordId,p_revision:revision,p_type:type}),cache:'no-store'});
   if(!response.ok){let detail;try{detail=await response.json();}catch{}const error=Error(detail?.code==='PT409'?'Another edit was saved first. Your draft is retained; copy it before reloading.':detail?.code==='PGRST202'?'Apply migration 015 for organization type editing before saving.':detail?.message||'Could not save this organization type.');error.code=detail?.code;throw error;}
   return response.json();
  };
  window.campaignSession.saveConnectionLabel=async(recordId,relationshipId,revision,label)=>{
   if(!session||!window.campaignSession.isStoryteller)throw Error('Storyteller access required.');
   const response=await fetch(config.url+'/rest/v1/rpc/save_personal_connection_label',{method:'POST',headers:headers(),body:JSON.stringify({p_campaign:config.campaignId,p_record:recordId,p_relationship:relationshipId,p_revision:revision,p_label:label}),cache:'no-store'});
   if(!response.ok){let detail;try{detail=await response.json();}catch{}const error=Error(detail?.code==='40001'?'Another edit was saved first. Your draft is retained; copy it before reloading.':detail?.code==='PGRST202'?'Apply migration 012 for personal connection labels before saving.':detail?.message||'Could not save this label.');error.code=detail?.code;throw error;}
   return response.json();
  };
  window.campaignSession.saveCoterie=async(kind,id,revision,payload)=>{
   if(!session||!window.campaignSession.isStoryteller)throw Error('Storyteller access required.');
   const response=await fetch(config.url+'/rest/v1/rpc/save_coterie_entry',{method:'POST',headers:headers(),body:JSON.stringify({p_campaign:config.campaignId,p_kind:kind,p_id:id||null,p_revision:revision,p_payload:payload}),cache:'no-store'});
   if(!response.ok){let detail;try{detail=await response.json();}catch{}throw Error(detail?.code==='PT409'?'Another edit was saved first. Your draft is retained; copy it before reloading.':detail?.code==='PGRST202'?'Apply the Coterie migration before saving.':detail?.message||'Could not save this coterie entry.');}
   return response.json();
  };
  window.campaignSession.ensureRoute=(route,id)=>!window.campaignSession.isStoryteller&&(route==='edit'||route==='storyteller')?Promise.resolve(loader.project()):loader.ensure(route,id);
  window.campaignSession.loadRecord=async id=>{
   await loader.record(id);let fresh=loader.project();
   // A record added in another tab can be referenced by this detail after login.
   // Refresh catalog dependencies, then restore the requested popup's full detail.
   if(validateCampaign(fresh).length){await loader.reload();await loader.record(id);fresh=loader.project();}
   return fresh;
  };
  window.campaignSession.searchRecords=query=>loader.search(query);
  window.campaignSession.reloadCampaign=()=>loader.reload();
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
  window.campaignSession.listAccessRequests=()=>rpc('list_pending_campaign_access_requests',{p_campaign:config.campaignId});
  window.campaignSession.reviewAccessRequest=(userId,approve)=>rpc('review_campaign_access_request',{p_campaign:config.campaignId,p_user:userId,p_approve:approve});
  if(window.campaignSession.isStoryteller){const tools=document.createElement('a');tools.href='#storyteller';tools.textContent='Storyteller';document.querySelector('#nav').append(tools);}
  document.querySelector('#nav').hidden=false;
  await new Promise((resolve,reject)=>{const script=document.createElement('script');script.src='app.js'+(appVersion?'?v='+encodeURIComponent(appVersion):'');script.onload=resolve;script.onerror=()=>reject(Error('Could not start the website. Reload to try again.'));document.body.append(script);});
  startRefresh();
 }
 const confirmed=new URLSearchParams(location.search).get('confirmed')==='1'||new URLSearchParams(location.hash.slice(1)).has('access_token');
 if(confirmed)history.replaceState(null,'',location.pathname);
 app.innerHTML='<section class="login-panel"><h1>Duluth by Night</h1><div class="auth-tabs"><button id="showSignIn" type="button" aria-pressed="true">Existing account</button><button id="showSignUp" type="button" aria-pressed="false">Create account</button></div><form id="signIn"><p>Sign in to your campaign account.</p><label>Email<input name="email" type="email" autocomplete="username" required></label><label>Password<input name="password" type="password" autocomplete="current-password" required></label><button type="submit">Sign in</button><p id="authMessage" role="status" aria-live="polite"></p></form><form id="signUp" hidden><p>Create your own account, confirm your email, then request access from the Storyteller.</p><label>Email<input name="signupEmail" type="email" autocomplete="email" required></label><label>Password<input name="signupPassword" type="password" autocomplete="new-password" minlength="8" required></label><label>Confirm password<input name="confirmPassword" type="password" autocomplete="new-password" minlength="8" required></label><button type="submit">Create account</button><p id="signupMessage" role="status" aria-live="polite"></p></form></section>';
 document.querySelector('#nav').hidden=true;
 const signIn=document.querySelector('#signIn'),signUp=document.querySelector('#signUp'),showSignIn=document.querySelector('#showSignIn'),showSignUp=document.querySelector('#showSignUp');
 function selectAuthForm(create){signIn.hidden=create;signUp.hidden=!create;showSignIn.setAttribute('aria-pressed',String(!create));showSignUp.setAttribute('aria-pressed',String(create));(create?signUp:signIn).querySelector('input').focus();}
 showSignIn.onclick=()=>selectAuthForm(false);showSignUp.onclick=()=>selectAuthForm(true);
 if(confirmed)document.querySelector('#authMessage').textContent='Email confirmed. Sign in to request campaign access.';
 document.querySelector('#signIn').addEventListener('submit',async event=>{
  event.preventDefault();const form=event.currentTarget,button=form.querySelector('button'),message=document.querySelector('#authMessage');
  button.disabled=true;message.textContent='Signing in…';
  try{
   const result=await auth('token?grant_type=password',{email:form.elements.email.value.trim(),password:form.elements.password.value});
   session={...result,expires_at:result.expires_at||Date.now()/1000+result.expires_in};form.elements.password.value='';message.textContent='Loading campaign…';await load();
  }catch(error){session=null;window.CAMPAIGN=null;message.textContent=error.message;button.disabled=false;}
 });
 document.querySelector('#signUp').addEventListener('submit',async event=>{
  event.preventDefault();const form=event.currentTarget,button=form.querySelector('button[type=submit]'),message=document.querySelector('#signupMessage');
  if(form.elements.signupPassword.value!==form.elements.confirmPassword.value){message.textContent='The passwords do not match.';return;}
  button.disabled=true;message.textContent='Creating account…';
  try{
   const redirect=new URL('campaign.html?confirmed=1',location.href).href;
   const result=await auth('signup?redirect_to='+encodeURIComponent(redirect),{email:form.elements.signupEmail.value.trim(),password:form.elements.signupPassword.value});
   form.elements.signupPassword.value='';form.elements.confirmPassword.value='';
   if(result?.access_token){session={...result,expires_at:result.expires_at||Date.now()/1000+result.expires_in};message.textContent='Account created. Checking campaign access…';await load();}
   else message.textContent='Account created. Check your email and click the confirmation link, then sign in here.';
  }catch(error){message.textContent=error.message;button.disabled=false;}
 });
})();
