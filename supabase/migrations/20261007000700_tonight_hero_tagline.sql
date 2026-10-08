-- Make the existing homepage flavor line editable with the Tonight status controls.
begin;
do $$ declare owner_id uuid;begin
 select owner_user_id into owner_id from public.campaigns where id='duluth-by-night';
 if owner_id is not null then
  perform set_config('request.jwt.claim.sub',owner_id::text,true);
  perform set_config('request.jwt.claims',json_build_object('sub',owner_id,'role','authenticated')::text,true);
 end if;
end $$;
insert into public.campaign_status(campaign_id,id,label,value,sort_order,audience,origin)
select id,'hero-tagline','Hero tagline','The lake is black. The harbor never sleeps. Every favor leaves a mark.',-1,'players','import'
from public.campaigns where id='duluth-by-night'
on conflict(campaign_id,id) do nothing;
commit;
