const {chromium}=require('playwright'),assert=require('node:assert/strict'),{exportDraft}=require('../scripts/export-supabase-draft.cjs'),{pageBundle}=require('./helpers/page-bundles.cjs');
(async()=>{const browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']});try{
 const rows=exportDraft().tables,page=await browser.newPage(),errors=[],calls=[];let failure=null,role='storyteller';
 for(const list of Object.values(rows))for(const row of list)row.revision=1;
 for(const [slug,value]of [['missing-type',null],['existing-type','Organization']]){
  const id='organization:'+slug;rows.records.push({id,record_type:'organization',route_key:slug,display_name:slug,audience:'players',revision:1});
  rows.sections.push({id:'section:'+slug,record_id:id,template_key:'facts',heading:'Facts',audience:'storyteller',revision:1});
  if(value)rows.content_items.push({id:'item:'+slug,record_id:id,section_id:'section:'+slug,item_kind:'fact',field_key:'organization.kind',value,value_type:'string',audience:'storyteller',revision:1});
 }
 page.on('pageerror',e=>errors.push(e.message));
 await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
  const req=route.request(),url=new URL(req.url()),name=url.pathname.split('/').pop();let body,status=200;
  if(name==='token')body={access_token:'fixture',refresh_token:'fixture',expires_in:3600,user:{id:role}};
  else if(name==='campaign_memberships')body=[{user_id:role,role,active:true}];else if(name==='campaigns')body=[{owner_user_id:'storyteller'}];
  else if(name==='load_campaign_page'){const p=req.postDataJSON();assert.notEqual(p.p_scope,'editor');body=pageBundle(rows,p.p_scope,p.p_record);}
  else if(name==='save_organization_type'){
   const p=req.postDataJSON();calls.push(p);
   if(failure){status=failure==='PGRST202'?404:409;body={code:failure};failure=null;}
   else{let item=rows.content_items.find(x=>x.record_id===p.p_record&&x.field_key==='organization.kind');
    if(!item){item={id:'test:new-type',record_id:p.p_record,section_id:'section:missing-type',item_kind:'fact',field_key:'organization.kind',value_type:'string',audience:'storyteller',revision:0};rows.content_items.push(item);}
    item.value=p.p_type||null;item.knowledge_state=p.p_type?'recorded':'unrecorded';item.revision++;body=item;
   }
  }else if(name==='edit_campaign_rows'){
   const changes=req.postDataJSON().p_changes;calls.push({review:changes});
   if(failure){status=409;body={code:failure};failure=null;}
   else{for(const c of changes){const item=rows[c.table].find(x=>x.id===c.id);Object.assign(item,c.patch,{revision:item.revision+1});}body=[];}
  }else if(req.method()==='GET'){const offset=Number(url.searchParams.get('offset')||0);body=(rows[name]||[]).slice(offset,offset+500);}
  else throw Error('Unexpected request '+name);
  await route.fulfill({status,contentType:'application/json',body:JSON.stringify(body)});
 });
 const base=process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8028';
 const form=()=>page.locator('[data-organization-type]');
 const input=()=>form().getByRole('textbox',{name:'Organization type',exact:true});
 async function edit(slug){await page.goto(base+'/campaign.html#edit/organization%3A'+slug);await input().waitFor();}
 async function signIn(){await page.locator('[name=email]').fill('fixture@example.test');await page.locator('[name=password]').fill('fixture');await page.getByRole('button',{name:'Sign in',exact:true}).click();}
 await page.goto(base+'/campaign.html#edit/organization%3Amissing-type');await signIn();await input().waitFor();assert.equal(await input().inputValue(),'');
 await input().fill('  Coterie  ');failure='PGRST202';await form().getByRole('button',{name:'Save type',exact:true}).click();await page.getByText('Apply migration 015 for organization type editing before saving.',{exact:true}).waitFor();assert.equal(await input().inputValue(),'  Coterie  ');
 await form().getByRole('button',{name:'Save type',exact:true}).click();await page.getByText('Organization type saved.',{exact:true}).waitFor();assert.equal(calls.at(-1).p_type,'Coterie');assert.equal(calls.at(-1).p_revision,0);assert.equal(await input().inputValue(),'Coterie');
 await page.goto(base+'/campaign.html#organizations/missing-type');await page.getByRole('heading',{name:'missing-type',exact:true}).waitFor();assert((await page.locator('.facts').textContent()).includes('Coterie'));
 await edit('existing-type');assert.equal(await input().inputValue(),'Organization');await input().fill('Band');await form().getByRole('button',{name:'Save type',exact:true}).click();await page.getByText('Organization type saved.',{exact:true}).waitFor();assert.equal(rows.content_items.find(x=>x.id==='item:existing-type').value,'Band');assert.equal(calls.at(-1).p_revision,1);
 await input().fill('Freeform music collective');failure='PT409';await form().getByRole('button',{name:'Save type',exact:true}).click();await page.getByText(/Another edit was saved first/).waitFor();assert.equal(await input().inputValue(),'Freeform music collective');
 await input().fill('');await form().getByRole('button',{name:'Save type',exact:true}).click();await page.getByText('Organization type saved.',{exact:true}).waitFor();assert.equal(rows.content_items.find(x=>x.id==='item:existing-type').value,null);
 // A shared type uses the existing reveal preview; cancellation writes nothing.
 rows.content_items.find(x=>x.id==='item:existing-type').audience='players';await page.getByRole('button',{name:'Reload saved entries',exact:true}).click();await form().getByRole('button',{name:'Review and save type',exact:true}).waitFor();await page.waitForFunction(async()=>{const current=document.querySelector('[data-organization-type]');await new Promise(resolve=>setTimeout(resolve,200));return current&&current===document.querySelector('[data-organization-type]');});
 await input().fill('Sect');const count=calls.length;await form().getByRole('button',{name:'Review and save type',exact:true}).click();await page.locator('.reveal-dialog').waitFor();assert.equal(calls.length,count);await page.getByRole('button',{name:'Cancel',exact:true}).click();assert.equal(calls.length,count);assert.equal(await input().inputValue(),'Sect');
 await form().getByRole('button',{name:'Review and save type',exact:true}).click();failure='PT409';await page.getByRole('button',{name:'Reveal these entries',exact:true}).click();await page.getByText('Nothing was saved. Cancel this review, copy any draft text you need, then reload saved entries and review your edits.',{exact:true}).waitFor();assert.equal(await input().inputValue(),'Sect');await page.getByRole('button',{name:'Cancel',exact:true}).click();
 await form().getByRole('button',{name:'Review and save type',exact:true}).click();await page.getByRole('button',{name:'Reveal these entries',exact:true}).click();await page.waitForFunction(()=>!document.querySelector('.reveal-dialog')?.open);assert(calls.at(-1).review.some(x=>x.id==='item:existing-type'&&x.patch.value==='Sect'));
 for(const width of [375,1280]){await page.setViewportSize({width,height:950});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
 await page.goto(base+'/campaign.html#edit/person%3Aalan-sovereign');await page.getByRole('heading',{name:'Edit Alan Sovereign',exact:true}).waitFor();assert.equal(await form().count(),0);
 role='player';await page.goto(base+'/campaign.html#organizations/existing-type');await page.reload();await signIn();await page.getByRole('heading',{name:'existing-type',exact:true}).waitFor();assert.equal(await form().count(),0);assert.equal(await page.getByText('Edit record & reveals',{exact:true}).count(),0);
 assert.deepEqual(errors,[]);console.log('PASS: organization type plain-text create/edit/clear, generic label replacement, migration/conflict drafts, shared review/cancel/conflict/save, scoped loading, organization-only/Storyteller UI and responsive layout.');
}finally{await browser.close();}})().catch(e=>{console.error(e);process.exit(1)});
