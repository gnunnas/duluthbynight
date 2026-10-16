const {chromium}=require('playwright'),assert=require('node:assert/strict'),{exportDraft}=require('../scripts/export-supabase-draft.cjs'),{pageBundle}=require('./helpers/page-bundles.cjs');
(async()=>{const browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']});try{
 const rows=exportDraft().tables,page=await browser.newPage(),errors=[],calls=[];let conflict=false;
 for(const list of Object.values(rows))for(const row of list)row.revision=1;
 page.on('pageerror',e=>errors.push(e.message));
 await page.route('https://xrkvbbmilgdubbwuffhu.supabase.co/**',async route=>{
  const req=route.request(),name=new URL(req.url()).pathname.split('/').pop();let body,status=200;
  if(name==='token')body={access_token:'fixture',refresh_token:'fixture',expires_in:3600,user:{id:'st'}};
  else if(name==='campaign_memberships')body=[{user_id:'st',role:'storyteller',active:true}];else if(name==='campaigns')body=[{owner_user_id:'st'}];
  else if(name==='load_campaign_page'){const p=req.postDataJSON();body=pageBundle(rows,p.p_scope,p.p_record);}
  else if(name==='save_record_summary'){
   const p=req.postDataJSON();calls.push(p);
   if(conflict){conflict=false;status=409;body={code:'40001'};}
   else{let item=rows.content_items.find(x=>x.record_id===p.p_record&&x.field_key==='overview');
    if(!item){const section='test:summary-section';rows.sections.push({id:section,record_id:p.p_record,template_key:'overview',heading:'Summary',audience:'storyteller',revision:1});item={id:'test:summary',record_id:p.p_record,section_id:section,item_kind:'note',field_key:'overview',audience:'storyteller',revision:0};rows.content_items.push(item);}
    item.body=p.p_body;item.knowledge_state=p.p_body?'recorded':'unrecorded';item.revision++;body=item;
   }
  }else if(name==='edit_campaign_rows'){const changes=req.postDataJSON().p_changes;calls.push({review:changes});for(const c of changes)Object.assign(rows[c.table].find(x=>x.id===c.id),c.patch);body=[];}
  else if(req.method()==='GET'){const offset=Number(new URL(req.url()).searchParams.get('offset')||0);body=(rows[name]||[]).slice(offset,offset+500);}
  else throw Error('Unexpected request '+name);
  await route.fulfill({status,contentType:'application/json',body:JSON.stringify(body)});
 });
 const base=process.env.CAMPAIGN_TEST_URL||'http://127.0.0.1:8028';
 await page.goto(base+'/campaign.html#edit/person%3Akevin-jackson');await page.locator('[name=email]').fill('st@example.test');await page.locator('[name=password]').fill('fixture');await page.getByRole('button',{name:'Sign in',exact:true}).click();
 const form=()=>page.locator('[data-summary-editor="person:kevin-jackson"]');await form().getByRole('textbox',{name:'Summary',exact:true}).waitFor();assert.equal(await form().getByRole('textbox').inputValue(),'');
 await form().getByRole('textbox').fill('A newly recorded introduction.');await form().getByRole('button',{name:'Save summary',exact:true}).click();await page.getByText('Summary saved.',{exact:true}).waitFor();assert.equal(calls.at(-1).p_revision,0);
 await page.evaluate(()=>location.hash='#people');await page.getByRole('heading',{name:'People',exact:true}).waitFor();assert.equal(await page.getByRole('button',{name:'Kindred',exact:true}).getAttribute('aria-pressed'),'true');assert.equal((await page.locator('[aria-label="Filter people"] button').allTextContents()).at(-1),'All');await page.getByRole('button',{name:'All',exact:true}).click();await page.locator('a.card[href="#people/kevin-jackson"]').getByText('A newly recorded introduction.',{exact:true}).waitFor();
 await page.evaluate(()=>location.hash='#people/kevin-jackson');await page.getByText('A newly recorded introduction.',{exact:true}).waitFor();
 await page.evaluate(()=>location.hash='#edit/person%3Akevin-jackson');await form().getByRole('textbox').waitFor();conflict=true;await form().getByRole('textbox').fill('Unsaved summary draft');await form().getByRole('button',{name:'Save summary',exact:true}).click();await form().getByText(/Another edit was saved first/).waitFor();assert.equal(await form().getByRole('textbox').inputValue(),'Unsaved summary draft');
 await form().getByRole('textbox').fill('');await form().getByRole('button',{name:'Save summary',exact:true}).click();await page.getByText('Summary saved.',{exact:true}).waitFor();assert.equal(calls.at(-1).p_revision,1);assert.equal(rows.content_items.filter(x=>x.record_id==='person:kevin-jackson'&&x.field_key==='overview').length,1);
 await page.evaluate(()=>location.hash='#people');const card=page.locator('a.card[href="#people/kevin-jackson"]');await card.waitFor();assert.equal(await card.locator('p').count(),0);
 rows.content_items.find(x=>x.id==='test:summary').audience='players';await page.evaluate(()=>location.hash='#edit/person%3Akevin-jackson');await page.getByRole('button',{name:'Reload saved entries',exact:true}).waitFor();await page.getByRole('button',{name:'Reload saved entries',exact:true}).click();await form().getByRole('button',{name:'Review and save summary',exact:true}).waitFor();await form().getByRole('textbox').fill('Reviewed shared summary.');
 const count=calls.length;await form().getByRole('button',{name:'Review and save summary',exact:true}).click();await page.getByRole('heading',{name:'Reveal to all campaign players?',exact:true}).waitFor();assert.equal(calls.length,count);await page.getByRole('button',{name:'Cancel',exact:true}).click();assert.equal(calls.length,count);
 await form().getByRole('button',{name:'Review and save summary',exact:true}).click();await page.getByRole('button',{name:'Reveal these entries',exact:true}).click();await page.waitForFunction(()=>!document.querySelector('.reveal-dialog')?.open);assert(calls.at(-1).review.some(x=>x.id==='test:summary'&&x.patch.body==='Reviewed shared summary.'));
 for(const width of [375,1280]){await page.setViewportSize({width,height:950});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));}
 assert.deepEqual(errors,[]);console.log('PASS: missing summary creation, card/profile display, clear without placeholder, draft conflict retention, public review/cancel/save and responsive layout.');
}finally{await browser.close();}})().catch(e=>{console.error(e);process.exit(1)});
