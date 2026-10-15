// API fixtures mirror page boundaries; PostgreSQL tests verify real RLS separately.
function pageBundle(rows,scope,id){
 if(scope==='editor')return rows;
 const fields=new Set(['overview','person.nature','place.kind','organization.kind','organization.browseCategory','session.date','session.inWorldDate','thread.status']);
 const items=(rows.content_items||[]).filter(r=>scope==='catalog'?!r.parent_item_id&&fields.has(r.field_key):r.record_id===id),itemIds=new Set(items.map(r=>r.id)),sections=new Set(items.map(r=>r.section_id)),out={};
 for(const [table,list]of Object.entries(rows)){
  if(scope==='catalog'){
   if(table==='content_items')out[table]=items;
   else if(table==='sections')out[table]=list.filter(r=>sections.has(r.id));
   else if(table==='attachments')out[table]=list.filter(r=>r.attachment_kind==='portrait'&&!r.item_id);
   else if(!['sources','item_references','selected_powers'].includes(table)&&!table.endsWith('_sources'))out[table]=list;
  }else if(table==='records')out[table]=list.filter(r=>r.id===id);
  else if(['record_names','sections','content_items','attachments'].includes(table))out[table]=list.filter(r=>r.record_id===id);
  else if(['item_references','selected_powers'].includes(table))out[table]=list.filter(r=>itemIds.has(r.item_id));
 }
 return out;
}
function searchRecords(rows,query){const q=query.trim().toLowerCase();return q?(rows.records||[]).filter(r=>[r.display_name,...(rows.record_names||[]).filter(n=>n.record_id===r.id).map(n=>n.text),...(rows.content_items||[]).filter(i=>i.record_id===r.id).map(i=>[i.title,i.body,JSON.stringify(i.value)].join(' '))].join(' ').toLowerCase().includes(q)).map(r=>r.id):[];}
module.exports={pageBundle,searchRecords};
