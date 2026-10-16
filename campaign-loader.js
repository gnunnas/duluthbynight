// Account-local memory cache; every fetched bundle is filtered by Supabase RLS.
(function(root){
 const routes={people:'person',places:'place',organizations:'organization',clans:'clan',chronicle:'session',threads:'thread',schemes:'scheme',events:'event',disciplines:'discipline',powers:'power',notes:'note'};
 function createCampaignLoader(request,campaignId){
  const rows={},loaded=new Set(),editable=new Set(),pending=new Map();let editor=false,editorTask=null,epoch=0,last={route:'home',id:null};
  const key=(table,row)=>row.id||row.power_record_id||row.old_route||[row.owner_id,row.source_id].join('|');
  const project=()=>root.adaptSupabase(rows,campaignId);
  function merge(bundle,replace=false){
   if(replace)for(const table of Object.keys(rows))delete rows[table];
   for(const [table,values]of Object.entries(bundle)){const entries=new Map((rows[table]||[]).map(row=>[key(table,row),row]));for(const row of values)entries.set(key(table,row),row);rows[table]=[...entries.values()];}
  }
  async function bundle(scope,id){const version=epoch,result=await request('load_campaign_page',{p_campaign:campaignId,p_scope:scope,p_record:id||null});if(version!==epoch)throw Error('Campaign session changed.');return result;}
  async function catalog(){merge(await bundle('catalog'),true);loaded.clear();editable.clear();editor=false;return project();}
  async function record(id,forEditing=false){
   if(editorTask)await editorTask;
   if(editor||(forEditing?editable:loaded).has(id))return;
   if(pending.has(id)){await pending.get(id);return record(id,forEditing);}
   const task=(async()=>{
    const result=await bundle(forEditing?'record-editor':'detail',id);
    if(!result.records?.some(row=>row.id===id)){await catalog();return;}
    // Replace owner collections, including entries removed since a catalog was loaded.
    const itemIds=new Set([...(rows.content_items||[]).filter(row=>row.record_id===id),...(result.content_items||[])].map(row=>row.id));
    for(const table of ['record_names','sections','content_items','attachments'])rows[table]=(rows[table]||[]).filter(row=>row.record_id!==id);
    for(const table of ['selected_powers','item_references'])rows[table]=(rows[table]||[]).filter(row=>!itemIds.has(row.item_id));
    if(forEditing)rows.sources=(rows.sources||[]).filter(row=>row.note_record_id!==id);
    merge(result);loaded.add(id);if(forEditing)editable.add(id);
   })();pending.set(id,task);try{await task;}finally{if(pending.get(id)===task)pending.delete(id);}
  }
  async function reviewData(){
   if(!editor){
    if(!editorTask){epoch++;pending.clear();editorTask=(async()=>{merge(await bundle('editor'),true);loaded.clear();editable.clear();editor=true;})();}
    const task=editorTask;try{await task;}finally{if(editorTask===task)editorTask=null;}
   }
  }
  async function ensure(route,id){
   last={route,id};
   if(route==='edit'){
    if(!(rows.records||[]).some(row=>row.id===id))await catalog();
    if((rows.records||[]).some(row=>row.id===id))await record(id,true);
   }else if(route==='coterie')await record('organization:player-coterie');
   else if(id){let target=(rows.records||[]).find(row=>row.record_type===routes[route]&&(row.route_key===id||row.id===id));if(!target){await catalog();target=(rows.records||[]).find(row=>row.record_type===routes[route]&&(row.route_key===id||row.id===id));}if(target)await record(target.id);}
   return project();
  }
  async function reload(){const previous=last;epoch++;pending.clear();editorTask=null;await catalog();return ensure(previous.route,previous.id);}
  function clear(){epoch++;pending.clear();editorTask=null;loaded.clear();editor=false;editable.clear();for(const table of Object.keys(rows))delete rows[table];}
  return {rows,catalog,ensure,record,reviewData,project,reload,clear,search:query=>request('search_campaign_records',{p_campaign:campaignId,p_query:query})};
 }
 root.createCampaignLoader=createCampaignLoader;
 if(typeof module!=='undefined')module.exports={createCampaignLoader};
})(globalThis);
