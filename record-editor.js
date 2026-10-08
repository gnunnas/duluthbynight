// Storyteller authoring UI. Database RPC verifies roles, fields, ownership, revisions and constraints.
(function(root){
 const esc=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
 const fields={
 records:['display_name','audience','archived_at','archive_reason'],record_names:['text','name_kind','context','valid_from','valid_until','audience'],
 sections:['heading','display_style','sort_order','audience'],
 content_items:['item_kind','field_key','value_type','title','body','value','qualifier','knowledge_state','sort_order','title_record_id','reference_record_id','perspective_record_id','section_id','parent_item_id','subject_relationship_id','subject_claim_id','subject_name_id','valid_from','valid_until','audience'],
 relationships:['relationship_type','from_record_id','to_record_id','context_record_id','perspective_record_id','knowledge_state','valid_from','valid_until','audience'],
 domain_claims:['place_id','claimant_record_id','status','valid_from','valid_until','audience'],
 person_status:['permanently_dead','death_date','death_details','session_record_id','audience'],
 attachments:['attachment_kind','caption','legacy_path','storage_bucket','storage_path','alt_text','artist_credit','sort_order','item_id','audience'],
 sources:['source_kind','label','editorial_date','note_record_id','audience'],
 item_references:['item_id','target_record_id','label','audience'],selected_powers:['item_id','discipline_record_id','power_record_id','label','notes','audience'],
 membership_implications:['source_organization_id','target_organization_id','eligible_connection_types','enabled','audience'],power_definitions:['discipline_record_id','level']
 };
 const tableLabels={records:'Record name',record_names:'Names & aliases',sections:'Sections',content_items:'Fields & notes',relationships:'Connections',domain_claims:'Domain claims',person_status:'For Real Dead?',attachments:'Artwork',sources:'Source archives',item_references:'Links in text',selected_powers:'Selected discipline abilities',membership_implications:'Membership inheritance',power_definitions:'Discipline & level'};
 const rows=()=>root.campaignSession.editorRows();
 const get=(table,id)=>(rows()[table]||[]).find(x=>(x.id||x.power_record_id)===id);
 const key=row=>row.id||row.power_record_id;
 const record=id=>get('records',id);
 const choices=()=>[...(rows().records||[])].sort((a,b)=>a.display_name.localeCompare(b.display_name));
 const recordLabel=r=>r.display_name+' · '+r.record_type+' ('+r.route_key+')';
 const label=(table,row)=>row.title||row.heading||row.display_name||row.text||row.label||(row.field_key?row.field_key.split('.').at(-1).replace(/([a-z])([A-Z])/g,'$1 $2'):null)||(row.body?row.body.slice(0,90):null)||tableLabels[table];
 const jsonFields=new Set(['valid_from','valid_until','death_date','eligible_connection_types']);
 const isRecordRef=k=>k.endsWith('_record_id')||['place_id','source_organization_id','target_organization_id'].includes(k);
 function options(table){return (rows()[table]||[]).map(x=>[key(x),label(table,x)]);}
 function formInput(table,row,column){
  const value=row[column],id=key(row),uid='edit-'+encodeURIComponent(table+id+column);
  let input;
  if(column==='audience'){
   const locked=(table==='content_items'&&['notes.storyteller','notes.player'].includes(row.field_key))||(table==='sections'&&row.template_key==='storyteller-notes');
   input=`<select name="${column}" ${locked?'disabled':''}>${[['storyteller','Storytellers only'],['players','All campaign players'],...(value==='public'?[['public','Public (already configured)']]:[])].map(([v,n])=>`<option value="${v}" ${v===value?'selected':''}>${n}</option>`).join('')}</select>`;
  }else if(isRecordRef(column)){
   input=`<input name="${column}" data-record-ref list="campaign-record-picker" value="${esc(record(value)?recordLabel(record(value)):'')}" placeholder="Search a person, place, clan, group…">`;
  }else if(['section_id','parent_item_id','subject_relationship_id','subject_claim_id','subject_name_id','item_id'].includes(column)){
   const source={section_id:'sections',parent_item_id:'content_items',subject_relationship_id:'relationships',subject_claim_id:'domain_claims',subject_name_id:'record_names',item_id:'content_items'}[column];
   let opts=options(source);if(['section_id','parent_item_id'].includes(column))opts=opts.filter(([v])=>get(source,v).record_id===row.record_id&&v!==row.id);
   input=`<select name="${column}"><option value="">None</option>${opts.map(([v,n])=>`<option value="${esc(v)}" ${v===value?'selected':''}>${esc(n)}</option>`).join('')}</select>`;
  }else if(column==='relationship_type')input=`<select name="${column}">${(rows().relationship_types||[]).map(t=>`<option value="${esc(t.id)}" ${t.id===value?'selected':''}>${esc(t.forward_label)}</option>`).join('')}</select>`;
  else if(column==='permanently_dead')input=`<select name="${column}">${['unknown','no','yes'].map(v=>`<option value="${v}" ${v===value?'selected':''}>${v==='unknown'?'Unknown':v==='yes'?'Yes':'No'}</option>`).join('')}</select>`;
  else if(typeof value==='boolean')input=`<select name="${column}" data-boolean><option value="true" ${value?'selected':''}>Yes</option><option value="false" ${!value?'selected':''}>No</option></select>`;
  else if(jsonFields.has(column)||column==='value'&&typeof value==='object'&&value!==null)input=`<textarea name="${column}" rows="4" data-json spellcheck="false">${esc(value===null?'':JSON.stringify(value,null,2))}</textarea><small>Structured details; preserve the JSON format. Leave blank for unknown.</small>`;
  else if(typeof value==='number'||['sort_order','level'].includes(column))input=`<input name="${column}" type="number" step="any" data-number value="${esc(value)}">`;
  else if(['body','notes','death_details','caption','archive_reason'].includes(column))input=`<textarea name="${column}" rows="4">${esc(value)}</textarea>`;
  else input=`<input name="${column}" value="${esc(value)}">`;
  return `<label for="${uid}">${esc(({display_name:'Name',value:'Value / mechanics',title_record_id:'Link the title to',reference_record_id:'Reference record',body:'Text',audience:'Visibility',permanently_dead:'For Real Dead?',sort_order:'Display order',archived_at:'Archived at (timestamp; clear to restore)'})[column]||column.replaceAll('_',' '))}<span>${input.replace(/<(input|textarea|select) /,'<$1 id="'+uid+'" ')}</span></label>`;
 }
 function rowForm(table,row){
  const id=key(row),protectedNote=table==='content_items'&&row.field_key==='notes.storyteller'||table==='sections'&&row.template_key==='storyteller-notes';
  const canReveal=row.audience&&!protectedNote&&row.field_key!=='notes.player'&&!row.archived_at;
  const addLink=table==='content_items';
  return `<details class="npc-panel editor-row"><summary><strong>${esc(label(table,row))}</strong> <span class="meta">${esc(row.audience==='players'?'Revealed':row.audience==='public'?'Public':row.audience?'Storyteller-only':'Reference data')}</span></summary>${canReveal?`<p><label class="reveal-choice"><input type="checkbox" data-share-table="${table}" data-share-id="${esc(id)}"> Reveal this entry to all players</label></p>`:''}<form data-edit-table="${table}" data-edit-id="${esc(id)}" data-revision="${row.revision}">${fields[table].filter(k=>!['field_key','item_kind','value_type','section_id','parent_item_id','subject_relationship_id','subject_claim_id','subject_name_id'].includes(k)).map(k=>formInput(table,row,k)).join('')}${table==='content_items'?`<details class="editor-advanced"><summary>Advanced field structure</summary>${fields[table].filter(k=>['field_key','item_kind','value_type','section_id','parent_item_id','subject_relationship_id','subject_claim_id','subject_name_id'].includes(k)).map(k=>formInput(table,row,k)).join('')}</details>`:''}${addLink?`<fieldset><legend>Add a link to this field</legend><label>Campaign record<input name="newLink" data-record-ref list="campaign-record-picker" placeholder="Search a campaign record"></label><label>Text to turn into a link<input name="newLinkLabel" placeholder="Exact words in the field"></label><small>Existing links can be edited below under Links in text. This adds a reference, not membership or geographic containment.</small></fieldset>`:''}<button type="submit" class="chip">Save entry</button><p role="status" aria-live="polite"></p></form></details>`;
 }
 function ownedRows(id){
  const data=rows(),itemIds=new Set((data.content_items||[]).filter(x=>x.record_id===id).map(x=>x.id));
  return Object.fromEntries(Object.entries(fields).map(([table])=>[table,(data[table]||[]).filter(row=>{
   if(table==='records')return row.id===id;
   if(table==='relationships')return [row.from_record_id,row.to_record_id].includes(id);
   if(table==='domain_claims')return [row.place_id,row.claimant_record_id].includes(id);
   if(table==='person_status')return row.person_record_id===id;
   if(table==='membership_implications')return [row.source_organization_id,row.target_organization_id].includes(id);
   if(table==='power_definitions')return row.power_record_id===id;
   if(table==='sources')return row.note_record_id===id;
   if(table==='item_references'||table==='selected_powers')return itemIds.has(row.item_id);
   return row.record_id===id;
  })]));
 }
 function recordLink(id){return `<p class="storyteller-actions"><a class="chip" href="#edit/${encodeURIComponent(id)}">Edit record &amp; reveals</a></p>`;}
 function picker(){return `<datalist id="campaign-record-picker">${choices().map(r=>`<option value="${esc(recordLabel(r))}"></option>`).join('')}</datalist>`;}
 function render(id){
  if(!root.campaignSession?.isStoryteller)return '<h1>Storyteller access required</h1><a href="#home">Return to Tonight</a>';
  const r=record(id);if(!r)return '<h1>Record not found</h1><a href="#storyteller">Storyteller tools</a>';
  return `<a class="back" href="#storyteller">← Storyteller tools</a><h1>Edit ${esc(r.display_name)}</h1><p class="intro">Save individual entries, or select entries and review a player reveal. IDs and existing bookmarks stay stable. Reveal all shares saved details, excluding Storyteller notes and archived entries. Save any drafts first.</p>${picker()}<div class="reveal-toolbar"><button class="chip" data-review-share type="button">Review selected reveals</button><button class="chip" data-share-overview="${esc(id)}" type="button">Share name + overview</button><button class="chip" data-share-all="${esc(id)}" type="button">Reveal all</button><button class="chip" data-editor-reload type="button">Reload saved entries</button></div><p id="editorMessage" role="status" aria-live="polite"></p>${Object.entries(ownedRows(id)).filter(([,values])=>values.length).map(([table,values])=>`<section class="editor-section"><h2>${tableLabels[table]}</h2>${values.map(row=>rowForm(table,row)).join('')}</section>`).join('')}`;
 }
 function dashboard(){
  if(!root.campaignSession?.isStoryteller)return '';
  return `<section class="npc-panel"><h2>Campaign records &amp; reveals</h2><label>Find a record<input type="search" data-editor-search placeholder="Name or record type"></label><p>Select records to share their names and overview text. Place categories are included to preserve the geographic hierarchy. Other details stay private.</p><button class="chip" data-dashboard-share type="button">Review names + overviews</button><button class="chip" data-homepage-share type="button">Review homepage records</button><div class="editor-record-list">${choices().map(r=>`<div data-editor-record data-search="${esc((r.display_name+' '+r.record_type).toLowerCase())}"><label><input type="checkbox" data-overview-record="${esc(r.id)}"> ${esc(r.display_name)} <small>${esc(r.record_type)} · ${r.audience==='players'?'Revealed':'Hidden'}</small></label>${recordLink(r.id)}</div>`).join('')}</div></section>`;
 }
 function overviewTargets(id){return [{table:'records',id},...(rows().content_items||[]).filter(x=>x.record_id===id&&x.field_key==='overview'&&!x.archived_at).map(x=>({table:'content_items',id:x.id}))];}
 function allTargets(id){
  // A protected or archived ancestor also excludes its nested entries and attachments.
  function itemEligible(itemId,seen=new Set()){
   if(!itemId)return true;if(seen.has(itemId))return false;seen.add(itemId);
   const item=get('content_items',itemId),section=item&&get('sections',item.section_id);
   return !!item&&!!section&&!item.archived_at&&!section.archived_at&&item.field_key!=='notes.storyteller'&&section.template_key!=='storyteller-notes'&&itemEligible(item.parent_item_id,seen);
  }
  return Object.entries(ownedRows(id)).flatMap(([table,entries])=>entries.filter(row=>{
   if(row.archived_at||!row.audience)return false;
   if(table==='sections')return row.template_key!=='storyteller-notes';
   if(table==='content_items')return itemEligible(row.id);
   if(['item_references','selected_powers','attachments'].includes(table))return itemEligible(row.item_id);
   return true;
  }).map(row=>({table,id:key(row)})));
 }
 function revealPlan(targets,edits=[]){
  const overrides=new Map(edits.filter(x=>!x.insert).map(x=>[x.table+':'+x.id,x.patch]));
  const plan=new Map(),visited=new Set();
  function add(table,id){if(!id)return;const token=table+':'+id;if(visited.has(token))return;visited.add(token);const original=get(table,id);const row=original?{...original,...overrides.get(token)}:null;if(!row)throw Error('A required linked entry is missing. Reload before revealing.');
   if(row.archived_at)throw Error('Restore archived entries before revealing them.');
   if(table==='content_items'&&row.field_key==='notes.storyteller'||table==='sections'&&row.template_key==='storyteller-notes')throw Error('Storyteller notes cannot be revealed.');
   if(row.audience&&row.audience==='storyteller')plan.set(token,{table,id,revision:row.revision,patch:{audience:'players'}});
   if(row.record_id)add('records',row.record_id);
   // Keep cities/districts separate from individual sites when a place becomes visible.
   if(table==='records'&&row.record_type==='place')for(const item of rows().content_items||[])if(item.record_id===id&&item.field_key==='place.kind'&&!item.archived_at)add('content_items',item.id);
   if(table==='content_items'){
    add('sections',row.section_id);add('content_items',row.parent_item_id);
    for(const k of ['title_record_id','reference_record_id','perspective_record_id'])add('records',row[k]);
    for(const [k,t]of [['subject_relationship_id','relationships'],['subject_claim_id','domain_claims'],['subject_name_id','record_names']])add(t,row[k]);
    // Attached inline links need explicit visibility too, but their targets only share names.
    for(const ref of rows().item_references||[])if(ref.item_id===id&&!ref.archived_at)add('item_references',ref.id);
   }
   if(table==='relationships')for(const k of ['from_record_id','to_record_id','context_record_id','perspective_record_id'])add('records',row[k]);
   if(table==='domain_claims'){add('records',row.place_id);add('records',row.claimant_record_id);}
   if(table==='item_references'){add('content_items',row.item_id);add('records',row.target_record_id);}
   if(table==='selected_powers'){add('content_items',row.item_id);add('records',row.power_record_id);add('records',row.discipline_record_id);}
   if(table==='attachments')add('content_items',row.item_id);
   if(table==='person_status'){add('records',row.person_record_id);add('records',row.session_record_id);}
   if(table==='membership_implications'){add('records',row.source_organization_id);add('records',row.target_organization_id);}
   if(table==='sources')add('records',row.note_record_id);
  }
  for(const target of targets)add(target.table,target.id);
  return [...plan.values()];
 }
 let dialog=null,pendingPlan=[],pendingTargets=[],pendingEdits=[];
 function review(targets,edits=[]){
  if(!targets.length)throw Error('Select entries to reveal first.');
  const merged=new Map(revealPlan(targets,edits).map(p=>[p.table+':'+p.id,p]));
  for(const edit of edits){const token=edit.table+':'+edit.id,existing=merged.get(token);merged.set(token,existing?{...edit,patch:{...existing.patch,...edit.patch}}:edit);}
  pendingTargets=targets;pendingEdits=edits;const plan=[...merged.values()];if(!plan.length)throw Error('These entries are already revealed.');pendingPlan=plan;
  dialog||=Object.assign(document.createElement('dialog'),{className:'reveal-dialog'});if(!dialog.isConnected)document.body.append(dialog);
  dialog.innerHTML=`<h2>Reveal to all campaign players?</h2><p>This saves ${plan.length} entries, including the parent sections and linked record names required for access. Only the listed entries will change. Storyteller notes stay private.</p><ul>${plan.map(p=>`<li>${esc(tableLabels[p.table])}: ${esc(label(p.table,get(p.table,p.id)))}${p.table==='content_items'?`<details><summary>Field content</summary><pre>${esc(JSON.stringify(Object.fromEntries(Object.entries({...get(p.table,p.id),...p.patch}).filter(([k])=>['body','value','title','field_key','audience'].includes(k))),null,2))}</pre></details>`:''}</li>`).join('')}</ul><button type="button" class="chip" data-confirm-reveal>Reveal these entries</button> <button type="button" class="chip" data-reload-reveal hidden>Reload and review again</button> <button type="button" class="chip" data-cancel-reveal>Cancel</button><p role="status" aria-live="polite"></p>`;
  if(!dialog.open)dialog.showModal();dialog.querySelector('[data-confirm-reveal]').focus();
 }
 function resolveRecord(text){if(!text.trim())return null;const found=choices().find(r=>recordLabel(r)===text);if(!found)throw Error('Choose a campaign record from the search suggestions.');return found.id;}
 document.addEventListener('submit',async event=>{
  const form=event.target.closest('form[data-edit-table]');if(!form)return;event.preventDefault();const button=form.querySelector('button'),message=form.querySelector('[role="status"]');if(button.disabled)return;
  button.disabled=true;message.textContent='Saving…';let committed=false;
  try{
   const table=form.dataset.editTable,row=get(table,form.dataset.editId),patch={};
   for(const k of fields[table]){const control=form.elements[k];if(!control||control.disabled)continue;let value=control.value;
    if(control.hasAttribute('data-record-ref'))value=resolveRecord(value);
    else if(control.hasAttribute('data-json'))value=value.trim()?JSON.parse(value):null;
    else if(control.hasAttribute('data-number')){value=value.trim()?Number(value):null;if(value!==null&&!Number.isFinite(value))throw Error('Enter a valid number.');}
    else if(control.hasAttribute('data-boolean'))value=value==='true';
    else if(value===''&&row[k]===null)value=null;
    if(JSON.stringify(value)!==JSON.stringify(row[k]))patch[k]=value;
   }
   const changes=Object.keys(patch).length?[{table,id:key(row),revision:Number(form.dataset.revision),patch}]:[];
   const linkText=form.elements.newLink?.value||'';if(linkText.trim()){
    const target=resolveRecord(linkText),labelText=form.elements.newLinkLabel.value.trim()||record(target).display_name;
    const body=String(patch.body??row.body??''),value=patch.value??row.value;
    if(!body.includes(labelText)&&!(typeof value==='string'&&value.includes(labelText)))throw Error('The link text must appear in this entry’s text or text value.');
    if(!changes.length)changes.push({table,id:key(row),revision:Number(form.dataset.revision),patch:{body:row.body}});
    changes.push({table:'item_references',id:'link:'+crypto.randomUUID(),revision:0,insert:true,patch:{item_id:row.id,target_record_id:target,label:labelText,audience:'storyteller'}});
   }
   if(!changes.length){message.textContent='No changes to save.';return;}
   if(patch.audience==='players'||row.audience==='players'&&patch.audience!=='storyteller'){review([{table,id:key(row)}],changes);message.textContent='Review the reveal before saving.';return;}
   await root.campaignSession.editRows(changes);committed=true;await root.refreshCampaignViews();const savedMessage=document.querySelector('#editorMessage');if(savedMessage)savedMessage.textContent='Saved. Entries reloaded from the database.';
  }catch(error){message.textContent=(committed?'Saved, but could not reload. Reload saved entries before editing again. ':'')+error.message;}finally{button.disabled=false;}
 });
 document.addEventListener('input',event=>{if(!event.target.matches('[data-editor-search]'))return;const q=event.target.value.toLowerCase();for(const node of document.querySelectorAll('[data-editor-record]'))node.hidden=!node.dataset.search.includes(q);});
 document.addEventListener('click',async event=>{
  const target=event.target.closest('button');if(!target)return;
  try{
   if(target.hasAttribute('data-cancel-reveal')){dialog.close();return;}
   if(target.hasAttribute('data-reload-reveal')){
    target.disabled=true;await root.campaignSession.reloadCampaign();
    if(pendingEdits.length){dialog.close();await root.refreshCampaignViews();const message=document.querySelector('#editorMessage');if(message)message.textContent='Reloaded. Review your field edits before saving again.';return;}
    const targets=pendingTargets;if(!revealPlan(targets).length){dialog.close();await root.refreshCampaignViews();const message=document.querySelector('#editorMessage');if(message)message.textContent='These entries are already revealed.';return;}review(targets);return;
   }
   if(target.hasAttribute('data-confirm-reveal')){
    if(target.disabled)return;target.disabled=true;const message=dialog.querySelector('[role="status"]');message.textContent='Revealing…';let committed=false;
    try{await root.campaignSession.editRows(pendingPlan);committed=true;await root.refreshCampaignViews();dialog.close();}
    catch(error){message.textContent=(committed?'Saved, but reload failed. ':'')+error.message;const conflict=['40001','PT409'].includes(error.code);if(conflict&&!committed){dialog.querySelector('[data-reload-reveal]').hidden=pendingEdits.length>0;message.textContent=pendingEdits.length?'Nothing was saved. Cancel this review, copy any draft text you need, then reload saved entries and review your edits.':'Nothing in this batch was revealed. Some entries changed since this page loaded. Reload and review again before confirming.';}else if(!committed)target.disabled=false;message.tabIndex=-1;message.focus();}return;
   }
   if(target.hasAttribute('data-editor-reload')){target.disabled=true;await root.refreshCampaignViews();return;}
   if(target.hasAttribute('data-share-all')){review(allTargets(target.dataset.shareAll));return;}
   if(target.hasAttribute('data-share-overview')){review(overviewTargets(target.dataset.shareOverview));return;}
   if(target.hasAttribute('data-review-share')){review([...document.querySelectorAll('[data-share-table]:checked')].map(x=>({table:x.dataset.shareTable,id:x.dataset.shareId})));return;}
   if(target.hasAttribute('data-dashboard-share')){review([...document.querySelectorAll('[data-overview-record]:checked')].flatMap(x=>overviewTargets(x.dataset.overviewRecord)));return;}
   if(target.hasAttribute('data-homepage-share'))review(choices().filter(r=>['thread','session'].includes(r.record_type)&&!r.archived_at).flatMap(r=>overviewTargets(r.id)));
  }catch(error){target.disabled=false;const message=document.querySelector('#editorMessage');if(message)message.textContent=error.message;else{let p=document.querySelector('#recordEditorMessage');if(!p){p=document.createElement('p');p.id='recordEditorMessage';p.setAttribute('role','status');target.after(p);}p.textContent=error.message;}}
 });
 root.CampaignEditor={render,dashboard,recordLink,revealPlan};
 if(typeof module!=='undefined')module.exports={fields};
})(globalThis);
