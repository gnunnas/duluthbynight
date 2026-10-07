// Generate a reviewable, one-time SQL Editor import. Never connects to Supabase.
const fs=require('node:fs');
const {exportDraft}=require('./export-supabase-draft.cjs');
const quote=value=>"'"+value.replace(/'/g,"''")+"'";
function sqlValue(key,value){
 if(value===null)return 'null';
 if(['value','valid_from','valid_until','details'].includes(key)||typeof value==='object'&&!Array.isArray(value))return quote(JSON.stringify(value))+'::jsonb';
 if(Array.isArray(value))return quote('{'+value.map(x=>'"'+x.replace(/["\\]/g,'\\$&')+'"').join(',')+'}');
 if(typeof value==='boolean'||typeof value==='number')return String(value);
 return quote(value);
}
function buildImport(result=exportDraft()){
 const campaign=quote(result.campaignId);
 const lines=[`-- Generated from the repository campaign data. Review before running.
-- One-time import: existing records cause an error; no data is overwritten.
-- Ordinary content stays Storyteller-only. This does not make old site files private.
begin;
set local standard_conforming_strings = on;
do $$
declare owner_id uuid;
begin
 select owner_user_id into owner_id from public.campaigns where id=${campaign} for update;
 if owner_id is null then raise exception 'Initialize the campaign before importing'; end if;
 if exists(select 1 from public.records where campaign_id=${campaign}) then
  raise exception 'Campaign already contains records. Import stopped without overwriting anything';
 end if;
 perform set_config('request.jwt.claim.sub',owner_id::text,true);
 perform set_config('request.jwt.claims',json_build_object('sub',owner_id,'role','authenticated')::text,true);
end $$;`];
 for(const [table,rows] of Object.entries(result.tables))for(const row of rows){
  const columns=Object.keys(row);
  lines.push('insert into public.'+table+'('+columns.join(',')+') values('+columns.map(k=>sqlValue(k,row[k])).join(',')+');');
 }
 lines.push('set constraints all immediate;','do $$ begin');
 for(const [table,rows] of Object.entries(result.tables))lines.push(`if (select count(*) from public.${table} where campaign_id=${campaign})<>${rows.length} then raise exception 'Import count mismatch: ${table}'; end if;`);
 lines.push(`if exists(select 1 from public.records where campaign_id=${campaign} and audience<>'storyteller') then raise exception 'Unexpected record audience'; end if;`,
 `if exists(select 1 from public.change_events where campaign_id=${campaign} and origin='import' and actor_user_id is null) then raise exception 'Missing import actor'; end if;`,
 'end $$;','commit;',`select 'PASS: campaign data imported; ordinary content remains Storyteller-only.' as result;`);
 return lines.join('\n')+'\n';
}
if(require.main===module){
 const index=process.argv.indexOf('--out');
 if(index<0||!process.argv[index+1])throw Error('Usage: node scripts/build-supabase-import.cjs --out supabase/import/03_import_campaign.sql');
 const result=exportDraft();fs.writeFileSync(process.argv[index+1],buildImport(result));
 console.log(JSON.stringify(result.report.counts,null,2));
}
module.exports={buildImport};
