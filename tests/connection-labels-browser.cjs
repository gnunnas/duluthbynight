const {chromium}=require('playwright'),assert=require('node:assert/strict'),{exportDraft}=require('../scripts/export-supabase-draft.cjs'),{pageBundle}=require('./helpers/page-bundles.cjs');
(async()=>{const browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']});try{
 const rows=exportDraft().tables,page=await browser.newPage(),errors=[],calls=[];let conflict=false,failedPage=false;
 for(const list of Object.values(rows))for(const row of list)row.revision=1;
 for(let i=0;i<520;i++)rows.content_items.push({id:'test:editor-batch:'+i,record_id:'note:alan-sovereign',section_id:rows.sections.find(x=>x.record_id==='note:alan-sovereign').id,item_kind:'note',body:'Batched editor fixture '+i,audience:'storyteller',revision:1});
 page.on('pageerror',e=>errors.push(e.message));
 await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
  const req=route.request(),name=new URL(req.url()).pathname.split('/').pop();let body,status=200;
  if(name==='token')body={access_token:'fixture',refresh_token:'fixture',expires_in:3600,user:{id:'st'}};
  else if(name==='campaign_memberships')body=[{user_id:'st',role:'storyteller',active:true}];else if(name==='campaigns')body=[{owner_user_id:'st'}];
  else if(name==='load_campaign_page'){const p=req.postDataJSON();assert.notEqual(p.p_scope,'editor','Do not request the oversized editor RPC');body=pageBundle(rows,p.p_scope,p.p_record);}
  else if(name==='save_personal_connection_label'){
   const p=req.postDataJSON();calls.push(p);
   if(conflict){conflict=false;status=409;body={code:'40001'};}
   else{const sectionId='test:label-section';if(!rows.sections.some(x=>x.id===sectionId))rows.sections.push({id:sectionId,record_id:p.p_record,template_key:'connection-labels',heading:'Connection labels',audience:'storyteller',revision:1});
    let item=rows.content_items.find(x=>x.record_id===p.p_record&&x.subject_relationship_id===p.p_relationship&&x.field_key==='relationship.details');
    if(!item){item={id:'test:personal-label',record_id:p.p_record,section_id:sectionId,item_kind:'fact',field_key:'relationship.details',subject_relationship_id:p.p_relationship,audience:'storyteller',revision:0};rows.content_items.push(item);}
    item.value=p.p_label||null;item.revision++;item.knowledge_state=p.p_label?'recorded':'unrecorded';body=item;
   }
  }else if(name==='edit_campaign_rows'){calls.push({review:req.postDataJSON()});body=[];}
  else if(req.method()==='GET'){const offset=Number(new URL(req.url()).searchParams.get('offset')||0);if(name==='content_items'&&offset>0&&!failedPage){failedPage=true;status=500;body={code:'57014'};}else body=(rows[name]||[]).slice(offset,offset+500);}
  else throw Error('Unexpected request '+name);
  await route.fulfill({status,contentType:'application/json',body:JSON.stringify(body)});
 });
 await page.goto((process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8028')+'/campaign.html#edit/person%3Aalan-sovereign');await page.locator('[name=email]').fill('st@example.test');await page.locator('[name=password]').fill('fixture');await page.getByRole('button',{name:'Sign in',exact:true}).click();await page.getByRole('heading',{name:'Could not load this page',exact:true}).waitFor();assert(!(await page.evaluate(()=>window.campaignSession.editorRows().content_items.some(x=>x.id.startsWith('test:editor-batch:')))));await page.getByRole('button',{name:'Try again',exact:true}).click();await page.getByRole('heading',{name:'Personal connection labels',exact:true}).waitFor();
 assert.equal(await page.evaluate(()=>window.campaignSession.editorRows().content_items.filter(x=>x.id.startsWith('test:editor-batch:')).length),520);
 const form=()=>page.locator('[data-connection-label="relationship:alan:kevin"]');
 await form().getByRole('textbox').fill('Useful but barely trusted');await form().getByRole('button',{name:'Save label',exact:true}).click();await page.getByText('Connection label saved.',{exact:true}).waitFor();assert.equal(calls.at(-1).p_revision,0);assert.equal(calls.at(-1).p_record,'person:alan-sovereign');
 await page.evaluate(()=>location.hash='#people/alan-sovereign');await page.getByRole('heading',{name:'Alan Sovereign',exact:true}).waitFor();await page.getByText(/Kevin Jackson — Useful but barely trusted/).waitFor();assert(!(await page.locator('main').textContent()).includes('specific relationship unknown'));
 await page.evaluate(()=>location.hash='#people/kevin-jackson');await page.getByRole('heading',{name:'Kevin Jackson',exact:true}).waitFor();assert(!(await page.locator('main').textContent()).includes('Useful but barely trusted'));
 await page.evaluate(()=>location.hash='#edit/person%3Aalan-sovereign');await form().getByRole('textbox').waitFor();
 conflict=true;await form().getByRole('textbox').fill('Unsaved draft');await form().getByRole('button',{name:'Save label',exact:true}).click();await form().getByText(/Another edit was saved first/).waitFor();assert.equal(await form().getByRole('textbox').inputValue(),'Unsaved draft');
 await form().getByRole('textbox').fill('');await form().getByRole('button',{name:'Save label',exact:true}).click();await page.getByText('Connection label saved.',{exact:true}).waitFor();assert.equal(calls.at(-1).p_revision,1);
 // Revealed labels retain the existing review flow instead of using the private-label RPC.
 rows.content_items.find(x=>x.id==='test:personal-label').audience='players';await page.getByRole('button',{name:'Reload saved entries',exact:true}).click();await form().getByRole('button',{name:'Review and save label',exact:true}).waitFor();
 const count=calls.length;await form().getByRole('textbox').fill('Public label draft');await form().getByRole('button',{name:'Review and save label',exact:true}).click();await page.getByRole('heading',{name:'Reveal to all campaign players?',exact:true}).waitFor();assert.equal(calls.length,count);await page.getByRole('button',{name:'Cancel',exact:true}).click();
 for(const width of [375,1280]){await page.setViewportSize({width,height:950});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
 assert.deepEqual(errors,[]);console.log('PASS: paged editor completeness and failed-page retry; simple label creation/edit/clear UI, directional display, conflict draft retention, public-label review, mobile layout.');
}finally{await browser.close();}})().catch(e=>{console.error(e);process.exit(1)});
