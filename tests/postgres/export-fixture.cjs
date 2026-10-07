// Test-only SQL generation. No account IDs or remote connections.
const {exportDraft}=require('../../scripts/export-supabase-draft.cjs');
const result=exportDraft(),quote=s=>"'"+s.replace(/'/g,"''")+"'";
function sqlValue(key,value){
 if(value===null)return 'null';
 if(['value','valid_from','valid_until','details'].includes(key))return quote(JSON.stringify(value))+'::jsonb';
 if(Array.isArray(value))return quote('{'+value.map(x=>'"'+x.replace(/["\\]/g,'\\$&')+'"').join(',')+'}');
 if(typeof value==='object')return quote(JSON.stringify(value))+'::jsonb';
 if(typeof value==='boolean'||typeof value==='number')return String(value);
 return quote(value);
}
console.log('begin;');
console.log("insert into auth.users(id) values('00000000-0000-0000-0000-000000000001');");
console.log("insert into public.campaigns(id,name,owner_user_id) values('duluth-by-night','Duluth by Night','00000000-0000-0000-0000-000000000001');");
for(const [table,rows] of Object.entries(result.tables))for(const row of rows){
 const columns=Object.keys(row);console.log('insert into public.'+table+'('+columns.join(',')+') values('+columns.map(k=>sqlValue(k,row[k])).join(',')+');');
}
console.log('set constraints all immediate;');
console.log("do $$begin if (select count(*) from public.records)<>84 or (select count(*) from public.content_items)<>429 or (select count(*) from public.power_definitions)<>14 then raise exception 'Import counts differ';end if;end $$;");
console.log('rollback;');
