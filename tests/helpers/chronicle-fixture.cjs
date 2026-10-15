const {exportDraft}=require('../../scripts/export-supabase-draft.cjs');
function fixture(){
 const rows=exportDraft().tables,id='session:history-fixture';
 rows.records.push({id,record_type:'session',route_key:'history-fixture',display_name:'New session fixture',audience:'players'});
 rows.sections.push({id:'section:history-fixture',record_id:id,template_key:'facts',heading:'Summary'});
 rows.content_items.push({id:'item:history-date',record_id:id,section_id:'section:history-fixture',field_key:'session.date',value:{text:'April 10, 2027',calendar:'real_world',iso:'2027-04-10',precision:'day'}},{id:'item:history-world-date',record_id:id,section_id:'section:history-fixture',field_key:'session.inWorldDate',value:{text:'June 1998',calendar:'in_world',precision:'month'}},{id:'item:completed-hunt',record_id:'thread:kyra-hunt',section_id:rows.sections.find(s=>s.record_id==='thread:kyra-hunt').id,field_key:'thread.status',value:'completed'});
 return rows;
}
module.exports={fixture};
