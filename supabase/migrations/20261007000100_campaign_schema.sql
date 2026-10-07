-- Initial Duluth by Night schema. Supabase Auth and Storage must already exist.
-- One transaction: a failure rolls back the entire schema installation.
begin;

-- CHUNK: 01_campaign_access.sql
-- Reviewed schema: apply to a new, empty project after following the setup guide.
-- Supabase provides auth.users, auth.uid(), authenticated, anon and service_role.

create schema if not exists campaign_private;
revoke all on schema campaign_private from public;
grant usage on schema campaign_private to authenticated, anon;
create type public.campaign_role as enum ('storyteller','player');
create type public.content_audience as enum ('storyteller','players','public');
create type public.change_origin as enum ('human','import','ai_approved','system');
create table public.campaigns (
  id text primary key,
  name text not null check (length(trim(name)) > 0),
  owner_user_id uuid not null references auth.users(id),
  settings jsonb not null default '{}',
  created_at timestamptz not null default now()
);
create table public.campaign_memberships (
  campaign_id text not null references public.campaigns(id),
  user_id uuid not null references auth.users(id),
  role public.campaign_role not null,
  active boolean not null default true,
  joined_at timestamptz not null default now(),
  primary key(campaign_id,user_id)
);
-- Owner is the initial Storyteller and retains access if a membership is revoked.
create function campaign_private.is_storyteller(c text) returns boolean
language sql stable security definer set search_path = '' as $$
 select exists(select 1 from public.campaigns where id=c and owner_user_id=auth.uid())
 or exists(select 1 from public.campaign_memberships where campaign_id=c and user_id=auth.uid() and active and role='storyteller')
$$;
create function campaign_private.is_member(c text) returns boolean
language sql stable security definer set search_path = '' as $$
 select campaign_private.is_storyteller(c) or exists(select 1 from public.campaign_memberships where campaign_id=c and user_id=auth.uid() and active)
$$;
create function campaign_private.can_read(c text,a public.content_audience,archived timestamptz) returns boolean
language sql stable security definer set search_path = '' as $$
 select campaign_private.is_storyteller(c) or (archived is null and (a='public' or (a='players' and campaign_private.is_member(c))))
$$;
alter table public.campaigns enable row level security;
alter table public.campaign_memberships enable row level security;
create policy campaigns_read on public.campaigns for select using(campaign_private.is_member(id));
create policy members_read on public.campaign_memberships for select using(user_id=auth.uid() or campaign_private.is_storyteller(campaign_id));
create policy members_create on public.campaign_memberships for insert to authenticated with check(campaign_private.is_storyteller(campaign_id));
create policy members_update on public.campaign_memberships for update to authenticated using(campaign_private.is_storyteller(campaign_id)) with check(campaign_private.is_storyteller(campaign_id));
grant select on public.campaigns,public.campaign_memberships to authenticated;
grant insert,update on public.campaign_memberships to authenticated;
-- Campaign creation/ownership transfer is an administrative operation, not player self-service.
revoke all on all functions in schema campaign_private from public;
grant execute on all functions in schema campaign_private to authenticated,anon;

-- CHUNK: 02_records_and_content.sql
create type public.record_kind as enum ('person','place','clan','organization','thread','scheme','session','event','discipline','power','note');
create table public.records (
 campaign_id text not null references public.campaigns(id), id text not null,
 record_type public.record_kind not null, route_key text not null, display_name text not null,
 audience public.content_audience not null default 'storyteller',
 archived_at timestamptz, archive_reason text,
 revision bigint not null default 1, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id), updated_by uuid references auth.users(id),
 origin public.change_origin not null default 'human',
 primary key(campaign_id,id), unique(campaign_id,record_type,route_key),
 check(length(trim(display_name))>0 and length(trim(route_key))>0)
);
create table public.record_names (
 campaign_id text not null, id text not null, record_id text not null, text text not null,
 name_kind text not null default 'unspecified', context text, valid_from jsonb, valid_until jsonb,
 audience public.content_audience not null default 'storyteller', archived_at timestamptz,
 revision bigint not null default 1, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id), updated_by uuid references auth.users(id), origin public.change_origin not null default 'human',
 primary key(campaign_id,id),foreign key(campaign_id,record_id) references public.records(campaign_id,id)
);
create table public.sections (
 campaign_id text not null, id text not null, record_id text not null,
 template_key text, heading text not null, display_style text, sort_order integer not null default 0,
 audience public.content_audience not null default 'storyteller', archived_at timestamptz,
 revision bigint not null default 1, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id), updated_by uuid references auth.users(id), origin public.change_origin not null default 'human',
 primary key(campaign_id,id),unique(campaign_id,id,record_id),
 foreign key(campaign_id,record_id) references public.records(campaign_id,id)
);
create table public.relationship_types (
 campaign_id text not null references public.campaigns(id), id text not null,
 from_types public.record_kind[] not null,to_types public.record_kind[] not null,
 forward_label text not null,reverse_label text not null,is_symmetric boolean not null default false,
 primary key(campaign_id,id)
);
create table public.relationships (
 campaign_id text not null,id text not null,relationship_type text not null,
 from_record_id text not null,to_record_id text not null,context_record_id text,perspective_record_id text,
 knowledge_state text not null default 'recorded',valid_from jsonb,valid_until jsonb,
 audience public.content_audience not null default 'storyteller', archived_at timestamptz,
 revision bigint not null default 1, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id), updated_by uuid references auth.users(id), origin public.change_origin not null default 'human',
 primary key(campaign_id,id),check(from_record_id<>to_record_id),
 foreign key(campaign_id,relationship_type) references public.relationship_types(campaign_id,id),
 foreign key(campaign_id,from_record_id) references public.records(campaign_id,id),
 foreign key(campaign_id,to_record_id) references public.records(campaign_id,id),
 foreign key(campaign_id,context_record_id) references public.records(campaign_id,id),
 foreign key(campaign_id,perspective_record_id) references public.records(campaign_id,id)
);
create unique index one_active_geographic_parent on public.relationships(campaign_id,from_record_id)
 where relationship_type='contained_in' and archived_at is null and valid_until is null;
create table public.domain_claims (
 campaign_id text not null,id text not null,place_id text not null,claimant_record_id text,
 status text not null default 'unspecified' check(status in ('unspecified','asserted','recognized','contested','historical')),
 valid_from jsonb,valid_until jsonb,
 audience public.content_audience not null default 'storyteller', archived_at timestamptz,
 revision bigint not null default 1, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id), updated_by uuid references auth.users(id), origin public.change_origin not null default 'human',
 primary key(campaign_id,id),foreign key(campaign_id,place_id) references public.records(campaign_id,id),
 foreign key(campaign_id,claimant_record_id) references public.records(campaign_id,id)
);
create table public.content_items (
 campaign_id text not null,id text not null,record_id text not null,section_id text not null,parent_item_id text,
 item_kind text not null default 'note',field_key text,title text,body text,value jsonb,value_type text,qualifier text,
 knowledge_state text not null default 'unrecorded',sort_order integer not null default 0,
 title_record_id text,reference_record_id text,perspective_record_id text,
 subject_relationship_id text,subject_claim_id text,subject_name_id text,
 valid_from jsonb,valid_until jsonb,
 audience public.content_audience not null default 'storyteller', archived_at timestamptz,
 revision bigint not null default 1, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id), updated_by uuid references auth.users(id), origin public.change_origin not null default 'human',
 primary key(campaign_id,id),unique(campaign_id,id,record_id),unique(campaign_id,id,reference_record_id),
 foreign key(campaign_id,section_id,record_id) references public.sections(campaign_id,id,record_id),
 foreign key(campaign_id,parent_item_id,record_id) references public.content_items(campaign_id,id,record_id) deferrable initially deferred,
 foreign key(campaign_id,title_record_id) references public.records(campaign_id,id),
 foreign key(campaign_id,reference_record_id) references public.records(campaign_id,id),
 foreign key(campaign_id,perspective_record_id) references public.records(campaign_id,id),
 foreign key(campaign_id,subject_relationship_id) references public.relationships(campaign_id,id),
 foreign key(campaign_id,subject_claim_id) references public.domain_claims(campaign_id,id),
 foreign key(campaign_id,subject_name_id) references public.record_names(campaign_id,id),
 check(parent_item_id is null or parent_item_id<>id),
 check(num_nonnulls(subject_relationship_id,subject_claim_id,subject_name_id)<=1),
 check(field_key is distinct from 'notes.storyteller' or audience='storyteller'),
 check(field_key is distinct from 'notes.player' or audience='players')
);
create unique index one_author_note_per_record on public.content_items(campaign_id,record_id,field_key)
 where field_key in ('notes.player','notes.storyteller');
-- Inline references are separate rows, rather than unvalidated IDs inside JSON.
create table public.item_references (
 campaign_id text not null,id text not null,item_id text not null,target_record_id text not null,label text,
 audience public.content_audience not null default 'storyteller',archived_at timestamptz,
 revision bigint not null default 1, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id),updated_by uuid references auth.users(id),origin public.change_origin not null default 'human',
 primary key(campaign_id,id),foreign key(campaign_id,item_id) references public.content_items(campaign_id,id),
 foreign key(campaign_id,target_record_id) references public.records(campaign_id,id)
);
create table public.membership_implications (
 campaign_id text not null,id text not null,source_organization_id text not null,target_organization_id text not null,
 eligible_connection_types text[] not null,enabled boolean not null default true,
 audience public.content_audience not null default 'storyteller',archived_at timestamptz,
 revision bigint not null default 1, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id),updated_by uuid references auth.users(id),origin public.change_origin not null default 'human',
 primary key(campaign_id,id),check(source_organization_id<>target_organization_id),
 foreign key(campaign_id,source_organization_id) references public.records(campaign_id,id),
 foreign key(campaign_id,target_organization_id) references public.records(campaign_id,id),
 check(cardinality(eligible_connection_types)>0 and eligible_connection_types <@ array['member_of','associate_of','affiliated_with']::text[])
);
-- Single authoritative discipline/level assignment; adapter derives power_of links.
create table public.power_definitions (
 campaign_id text not null,power_record_id text not null,discipline_record_id text not null,level integer not null check(level between 1 and 5),
 primary key(campaign_id,power_record_id),unique(campaign_id,power_record_id,discipline_record_id),
 foreign key(campaign_id,power_record_id) references public.records(campaign_id,id),
 foreign key(campaign_id,discipline_record_id) references public.records(campaign_id,id)
);
create table public.selected_powers (
 campaign_id text not null,id text not null,item_id text not null,discipline_record_id text not null,power_record_id text not null,
 label text,notes text,
 audience public.content_audience not null default 'storyteller',archived_at timestamptz,
 revision bigint not null default 1, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id),updated_by uuid references auth.users(id),origin public.change_origin not null default 'human',
 primary key(campaign_id,id),unique(campaign_id,item_id,power_record_id),
 foreign key(campaign_id,item_id,discipline_record_id) references public.content_items(campaign_id,id,reference_record_id),
 foreign key(campaign_id,power_record_id,discipline_record_id) references public.power_definitions(campaign_id,power_record_id,discipline_record_id)
);
create table public.person_status (
 campaign_id text not null,id text not null,person_record_id text not null,
 permanently_dead text not null default 'unknown' check(permanently_dead in ('unknown','no','yes')),
 death_date jsonb,death_details text,session_record_id text,
 audience public.content_audience not null default 'storyteller',archived_at timestamptz,
 revision bigint not null default 1,created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id),updated_by uuid references auth.users(id),origin public.change_origin not null default 'human',
 primary key(campaign_id,id),unique(campaign_id,person_record_id),
 foreign key(campaign_id,person_record_id) references public.records(campaign_id,id),
 foreign key(campaign_id,session_record_id) references public.records(campaign_id,id)
);
create table public.sources (
 campaign_id text not null,id text not null,source_kind text not null,label text,editorial_date text,note_record_id text,
 audience public.content_audience not null default 'storyteller',archived_at timestamptz,
 revision bigint not null default 1,created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id),updated_by uuid references auth.users(id),origin public.change_origin not null default 'human',
 primary key(campaign_id,id),foreign key(campaign_id,note_record_id) references public.records(campaign_id,id)
);
create table public.attachments (
 campaign_id text not null,id text not null,record_id text not null,item_id text,attachment_kind text,
 storage_bucket text,storage_path text,legacy_path text,alt_text text,caption text,artist_credit text,sort_order integer not null default 0,
 audience public.content_audience not null default 'storyteller',archived_at timestamptz,
 revision bigint not null default 1,created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id),updated_by uuid references auth.users(id),origin public.change_origin not null default 'human',
 primary key(campaign_id,id),foreign key(campaign_id,record_id) references public.records(campaign_id,id),
 foreign key(campaign_id,item_id,record_id) references public.content_items(campaign_id,id,record_id),
 check((storage_bucket is null)=(storage_path is null))
);
create table public.route_aliases (
 campaign_id text not null references public.campaigns(id),old_route text not null,target_route text not null,
 primary key(campaign_id,old_route),check(old_route<>target_route)
);
-- Keep migration caveats instead of silently resolving uncertain geography.
create table public.review_issues (
 campaign_id text not null,id text not null,record_id text not null,details jsonb not null,
 primary key(campaign_id,id),foreign key(campaign_id,record_id) references public.records(campaign_id,id)
);
-- Provenance junctions use real foreign keys for each owning row type.
do $$ declare t text; begin
 foreach t in array array['record_names','content_items','relationships','domain_claims','membership_implications','attachments','power_definitions'] loop
  execute format('create table public.%I (campaign_id text not null, owner_id text not null, source_id text not null, locator text, primary key(campaign_id,owner_id,source_id), foreign key(campaign_id,owner_id) references public.%I(campaign_id,%I), foreign key(campaign_id,source_id) references public.sources(campaign_id,id))',t||'_sources',t,case when t='power_definitions' then 'power_record_id' else 'id' end);
 end loop;
end $$;
create index records_campaign_browse on public.records(campaign_id,record_type,display_name);
create index items_record_order on public.content_items(campaign_id,record_id,section_id,sort_order);
create index relationships_forward on public.relationships(campaign_id,from_record_id);
create index relationships_reverse on public.relationships(campaign_id,to_record_id);
-- Fail closed until chunk 04 installs policies; no website switch is performed here.
do $$ declare t record; begin
 for t in select tablename from pg_tables where schemaname='public' and tablename=any(array['campaigns','campaign_memberships','records','record_names','sections','relationship_types','relationships','domain_claims','content_items','item_references','membership_implications','power_definitions','selected_powers','person_status','sources','attachments','route_aliases','review_issues','record_names_sources','content_items_sources','relationships_sources','domain_claims_sources','membership_implications_sources','attachments_sources','power_definitions_sources']) loop execute format('alter table public.%I enable row level security',t.tablename);end loop;
end $$;

-- CHUNK: 03_history_and_integrity.sql
-- Used only internally for triggers/policies, never for dynamic client-supplied SQL.
create function campaign_private.mutable_tables() returns text[] language sql immutable as $$
 select array['records','record_names','sections','relationships','domain_claims','content_items','item_references','membership_implications','selected_powers','person_status','sources','attachments']::text[]
$$;
create table public.change_proposals (
 campaign_id text not null references public.campaigns(id),id uuid not null default gen_random_uuid(),
 target_table text not null,target_id text,base_revision bigint,
 proposed_change jsonb not null,reason text,
 proposal_origin text not null default 'human' check(proposal_origin in ('human','ai')),
 ai_model text,ai_context jsonb,
 status text not null default 'draft' check(status in ('draft','approved','rejected','superseded')),
 created_by uuid references auth.users(id),created_at timestamptz not null default now(),
 reviewed_by uuid references auth.users(id),reviewed_at timestamptz,
 primary key(campaign_id,id),
 check(target_table=any(campaign_private.mutable_tables())),
 check((status in ('approved','rejected'))=(reviewed_by is not null and reviewed_at is not null))
);
create table public.change_events (
 id bigint generated always as identity primary key,
 campaign_id text not null references public.campaigns(id),table_name text not null,row_id text,
 operation text not null check(operation in ('INSERT','UPDATE','DELETE')),
 actor_user_id uuid references auth.users(id),origin public.change_origin not null,
 proposal_id uuid,changed_at timestamptz not null default now(),
 before_value jsonb,after_value jsonb,
 foreign key(campaign_id,proposal_id) references public.change_proposals(campaign_id,id)
);
create index history_campaign_time on public.change_events(campaign_id,changed_at desc,id desc);
create function campaign_private.stamp_change() returns trigger language plpgsql security definer set search_path='' as $$
begin
 if TG_OP='UPDATE' then
  if NEW.campaign_id<>OLD.campaign_id or NEW.id<>OLD.id then raise exception 'Identity and campaign cannot be changed';end if;
  if TG_TABLE_NAME='records' then
   if NEW.record_type<>OLD.record_type then raise exception 'Record type cannot be changed';end if;
  end if;
  -- Player edits affect only the body of a pre-existing shared player-note row.
  if auth.uid() is not null and not campaign_private.is_storyteller(NEW.campaign_id) then
   if TG_TABLE_NAME<>'content_items' or OLD.field_key is distinct from 'notes.player'
    or (to_jsonb(NEW)-array['body','knowledge_state','revision','updated_at','updated_by'])<>(to_jsonb(OLD)-array['body','knowledge_state','revision','updated_at','updated_by'])
    then raise exception 'Players may edit only shared player-note text';end if;
   NEW.knowledge_state=case when coalesce(NEW.body,'')='' then 'unrecorded' else 'recorded' end;
   NEW.origin='human';
  end if;
  NEW.revision=OLD.revision+1;NEW.created_at=OLD.created_at;NEW.created_by=OLD.created_by;
 else
  NEW.revision=1;NEW.created_at=now();NEW.created_by=auth.uid();
 end if;
 NEW.updated_at=now();NEW.updated_by=auth.uid();
 if NEW.origin='ai_approved' then
  if NEW.approved_proposal_id is null or not exists(select 1 from public.change_proposals p where p.campaign_id=NEW.campaign_id and p.id=NEW.approved_proposal_id and p.status='approved' and p.proposal_origin='ai' and p.target_table=TG_TABLE_NAME and p.target_id=NEW.id and p.base_revision=case when TG_OP='UPDATE' then OLD.revision else 0 end and to_jsonb(NEW) @> p.proposed_change)
  then raise exception 'AI changes require an approved proposal';end if;
 end if;
 return NEW;
end $$;
create function campaign_private.audit_change() returns trigger language plpgsql security definer set search_path='' as $$
declare row_data jsonb;begin
 row_data=case when TG_OP='DELETE' then to_jsonb(OLD) else to_jsonb(NEW) end;
 insert into public.change_events(campaign_id,table_name,row_id,operation,actor_user_id,origin,proposal_id,before_value,after_value)
 values(row_data->>'campaign_id',TG_TABLE_NAME,coalesce(row_data->>'id',row_data->>'user_id',row_data->>'power_record_id',row_data->>'old_route',row_data->>'owner_id'),TG_OP,auth.uid(),coalesce((row_data->>'origin')::public.change_origin,'human'),(row_data->>'approved_proposal_id')::uuid,
 case when TG_OP<>'INSERT' then to_jsonb(OLD) end,case when TG_OP<>'DELETE' then to_jsonb(NEW) end);
 return null;
end $$;
create function campaign_private.review_proposal() returns trigger language plpgsql security definer set search_path='' as $$
begin
 if TG_OP='INSERT' then
  NEW.created_by=auth.uid();NEW.created_at=now();
  if NEW.status<>'draft' then raise exception 'New proposals must be drafts';end if;
 else
  if NEW.campaign_id<>OLD.campaign_id or NEW.id<>OLD.id then raise exception 'Proposal identity cannot change';end if;
  NEW.created_by=OLD.created_by;NEW.created_at=OLD.created_at;
  if OLD.status<>'draft' then raise exception 'Reviewed proposals are immutable; create a new draft';end if;
 end if;
 if NEW.status in ('approved','rejected') then NEW.reviewed_by=auth.uid();NEW.reviewed_at=now();else NEW.reviewed_by=null;NEW.reviewed_at=null;end if;
 return NEW;
end $$;
create trigger proposal_review before insert or update on public.change_proposals for each row execute function campaign_private.review_proposal();
do $$ declare t text;begin
 foreach t in array campaign_private.mutable_tables() loop
  execute format('alter table public.%I add column approved_proposal_id uuid, add foreign key(campaign_id,approved_proposal_id) references public.change_proposals(campaign_id,id)',t);
  execute format('create trigger stamp_change before insert or update on public.%I for each row execute function campaign_private.stamp_change()',t);
 end loop;
 foreach t in array campaign_private.mutable_tables()||array['campaign_memberships','relationship_types','power_definitions','route_aliases','review_issues','change_proposals','record_names_sources','content_items_sources','relationships_sources','domain_claims_sources','membership_implications_sources','attachments_sources','power_definitions_sources'] loop
  execute format('create trigger audit_change after insert or update or delete on public.%I for each row execute function campaign_private.audit_change()',t);
 end loop;
end $$;
-- Campaign-row locking serializes graph changes, preventing two concurrent edits creating a cycle.
create function campaign_private.check_graph() returns trigger language plpgsql security definer set search_path='' as $$
declare from_kind public.record_kind;to_kind public.record_kind;rules public.relationship_types; cyclic boolean;begin
 perform 1 from public.campaigns where id=NEW.campaign_id for update;
 if TG_TABLE_NAME='relationships' then
  select record_type into from_kind from public.records where campaign_id=NEW.campaign_id and id=NEW.from_record_id;
  select record_type into to_kind from public.records where campaign_id=NEW.campaign_id and id=NEW.to_record_id;
  select * into rules from public.relationship_types where campaign_id=NEW.campaign_id and id=NEW.relationship_type;
  if not (from_kind=any(rules.from_types) and to_kind=any(rules.to_types)) then raise exception 'Invalid relationship endpoint types';end if;
  if rules.is_symmetric and NEW.from_record_id>NEW.to_record_id then
   declare temp text;begin temp=NEW.from_record_id;NEW.from_record_id=NEW.to_record_id;NEW.to_record_id=temp;end;
  end if;
  if exists(select 1 from public.relationships r where r.campaign_id=NEW.campaign_id and r.id<>NEW.id and r.relationship_type=NEW.relationship_type and r.from_record_id=NEW.from_record_id and r.to_record_id=NEW.to_record_id and r.context_record_id is not distinct from NEW.context_record_id and r.valid_from is not distinct from NEW.valid_from and r.valid_until is not distinct from NEW.valid_until and r.archived_at is null and NEW.archived_at is null) then raise exception 'Duplicate relationship';end if;
  if NEW.relationship_type='power_of' then raise exception 'Use power_definitions as the authoritative power assignment';end if;
  if NEW.archived_at is null and NEW.relationship_type in ('contained_in','subgroup_of') then
   with recursive path(id) as (
    select NEW.to_record_id union select r.to_record_id from public.relationships r join path p on p.id=r.from_record_id where r.campaign_id=NEW.campaign_id and r.relationship_type=NEW.relationship_type and r.id<>NEW.id and r.archived_at is null
   ) select exists(select 1 from path where id=NEW.from_record_id) into cyclic;
   if cyclic then raise exception 'Hierarchy cycle';end if;
  end if;
 elsif TG_TABLE_NAME='content_items' then
  if NEW.parent_item_id is not null then
  with recursive path(id) as(select NEW.parent_item_id union select i.parent_item_id from public.content_items i join path p on i.id=p.id where i.campaign_id=NEW.campaign_id and i.id<>NEW.id and i.parent_item_id is not null)
  select exists(select 1 from path where id=NEW.id) into cyclic;
  if cyclic then raise exception 'Item nesting cycle';end if;
  end if;
 elsif TG_TABLE_NAME='membership_implications' then
  if not exists(select 1 from public.records where campaign_id=NEW.campaign_id and id=NEW.source_organization_id and record_type='organization')
   or not exists(select 1 from public.records where campaign_id=NEW.campaign_id and id=NEW.target_organization_id and record_type='organization') then raise exception 'Implications require organizations';end if;
  if NEW.enabled and NEW.archived_at is null then
   with recursive path(id) as(select NEW.target_organization_id union select i.target_organization_id from public.membership_implications i join path p on p.id=i.source_organization_id where i.campaign_id=NEW.campaign_id and i.id<>NEW.id and i.enabled and i.archived_at is null)
   select exists(select 1 from path where id=NEW.source_organization_id) into cyclic;
   if cyclic then raise exception 'Membership implication cycle';end if;
  end if;
 end if;
 return NEW;
end $$;
create trigger check_graph before insert or update on public.relationships for each row execute function campaign_private.check_graph();
-- AFTER + deferred checks also catch insertion of both sides of a nesting cycle in one transaction.
create constraint trigger check_item_graph after insert or update on public.content_items deferrable initially deferred for each row execute function campaign_private.check_graph();
create trigger check_implication_graph before insert or update on public.membership_implications for each row execute function campaign_private.check_graph();
create function campaign_private.check_typed_row() returns trigger language plpgsql security definer set search_path='' as $$
begin
 if TG_TABLE_NAME='person_status' then
  if not exists(select 1 from public.records where campaign_id=NEW.campaign_id and id=NEW.person_record_id and record_type='person') then raise exception 'Death status requires a person';end if;
  if NEW.session_record_id is not null and not exists(select 1 from public.records where campaign_id=NEW.campaign_id and id=NEW.session_record_id and record_type='session') then raise exception 'Death session must be a session';end if;
 elsif TG_TABLE_NAME='domain_claims' then
  if not exists(select 1 from public.records where campaign_id=NEW.campaign_id and id=NEW.place_id and record_type='place') then raise exception 'Claim requires a place';end if;
  if NEW.claimant_record_id is not null and not exists(select 1 from public.records where campaign_id=NEW.campaign_id and id=NEW.claimant_record_id and record_type in ('person','organization')) then raise exception 'Claimant must be a person or organization';end if;
 elsif TG_TABLE_NAME='power_definitions' then
  if not exists(select 1 from public.records where campaign_id=NEW.campaign_id and id=NEW.power_record_id and record_type='power') or not exists(select 1 from public.records where campaign_id=NEW.campaign_id and id=NEW.discipline_record_id and record_type='discipline') then raise exception 'Power definition requires a power and discipline';end if;
 elsif TG_TABLE_NAME='selected_powers' then
  if not exists(select 1 from public.content_items i join public.power_definitions p on p.campaign_id=i.campaign_id where i.campaign_id=NEW.campaign_id and i.id=NEW.item_id and i.field_key='mechanics.discipline' and p.power_record_id=NEW.power_record_id and (i.value->>'rating')::numeric>=p.level) then raise exception 'Selected power exceeds rating or lacks discipline item';end if;
 end if;
 return NEW;
end $$;
do $$ declare t text;begin
 foreach t in array array['person_status','domain_claims','power_definitions','selected_powers'] loop
  execute format('create trigger check_typed_row before insert or update on public.%I for each row execute function campaign_private.check_typed_row()',t);
 end loop;
end $$;

-- Validate dependent assignments after changing ratings or levels, not just on selection creation.
create function campaign_private.check_power_consistency() returns trigger language plpgsql security definer set search_path='' as $$
begin
 perform 1 from public.campaigns where id=NEW.campaign_id for update;
 if TG_TABLE_NAME='content_items' then
  if NEW.item_kind='mechanic' and (jsonb_typeof(NEW.value->'rating') is distinct from 'number' or (NEW.value->>'rating')::numeric<0) then raise exception 'Mechanic rating must be a nonnegative number';end if;
  if NEW.field_key='mechanics.discipline' and NEW.reference_record_id is not null and not exists(select 1 from public.records where campaign_id=NEW.campaign_id and id=NEW.reference_record_id and record_type='discipline') then raise exception 'Discipline rating must reference a discipline';end if;
 end if;
 if exists(select 1 from public.selected_powers s join public.content_items i on i.campaign_id=s.campaign_id and i.id=s.item_id join public.power_definitions p on p.campaign_id=s.campaign_id and p.power_record_id=s.power_record_id where s.campaign_id=NEW.campaign_id and s.archived_at is null and (i.field_key is distinct from 'mechanics.discipline' or jsonb_typeof(i.value->'rating') is distinct from 'number' or (i.value->>'rating')::numeric<p.level)) then raise exception 'Existing selected power exceeds updated rating or level';end if;
 return null;
end $$;
create constraint trigger power_rating_consistency after insert or update on public.content_items deferrable initially deferred for each row execute function campaign_private.check_power_consistency();
create constraint trigger power_level_consistency after insert or update on public.power_definitions deferrable initially deferred for each row execute function campaign_private.check_power_consistency();
create function campaign_private.registry_change_valid() returns trigger language plpgsql security definer set search_path='' as $$
begin
 perform 1 from public.campaigns where id=NEW.campaign_id for update;
 if exists(select 1 from public.relationships r join public.records a on a.campaign_id=r.campaign_id and a.id=r.from_record_id join public.records b on b.campaign_id=r.campaign_id and b.id=r.to_record_id where r.campaign_id=NEW.campaign_id and r.relationship_type=NEW.id and (not a.record_type=any(NEW.from_types) or not b.record_type=any(NEW.to_types))) then raise exception 'Registry edit invalidates existing endpoints';end if;
 if TG_OP='UPDATE' and NEW.is_symmetric is distinct from OLD.is_symmetric then raise exception 'Relationship symmetry is immutable; use a new type';end if;
 return NEW;
end $$;
create trigger registry_change_valid before insert or update on public.relationship_types for each row execute function campaign_private.registry_change_valid();

-- CHUNK: 04_permissions.sql
create function campaign_private.record_readable(c text,r text) returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.records where campaign_id=c and id=r and campaign_private.can_read(c,audience,archived_at))
$$;
create function campaign_private.section_readable(c text,s text) returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.sections where campaign_id=c and id=s and campaign_private.can_read(c,audience,archived_at) and campaign_private.record_readable(c,record_id))
$$;
create function campaign_private.name_readable(c text,n text) returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.record_names where campaign_id=c and id=n and campaign_private.can_read(c,audience,archived_at) and campaign_private.record_readable(c,record_id))
$$;
create function campaign_private.relationship_readable(c text,r text) returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.relationships where campaign_id=c and id=r and campaign_private.can_read(c,audience,archived_at)
 and campaign_private.record_readable(c,from_record_id) and campaign_private.record_readable(c,to_record_id)
 and (context_record_id is null or campaign_private.record_readable(c,context_record_id))
 and (perspective_record_id is null or campaign_private.record_readable(c,perspective_record_id)))
$$;
create function campaign_private.claim_readable(c text,r text) returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.domain_claims where campaign_id=c and id=r and campaign_private.can_read(c,audience,archived_at)
 and campaign_private.record_readable(c,place_id) and (claimant_record_id is null or campaign_private.record_readable(c,claimant_record_id)))
$$;
create function campaign_private.item_readable(c text,item text) returns boolean language plpgsql stable security definer set search_path='' as $$
declare i public.content_items;begin
 select * into i from public.content_items where campaign_id=c and id=item;
 if not found then return false;end if;
 if campaign_private.is_storyteller(c) then return true;end if;
 if not campaign_private.section_readable(c,i.section_id) or not campaign_private.record_readable(c,i.record_id) then return false;end if;
 if exists(with recursive ancestors as (
  select * from public.content_items where campaign_id=c and id=item
  union select p.* from public.content_items p join ancestors a on a.parent_item_id=p.id and a.campaign_id=p.campaign_id
 ) select 1 from ancestors a where not campaign_private.can_read(c,a.audience,a.archived_at)
  or not campaign_private.section_readable(c,a.section_id)
  or (a.title_record_id is not null and not campaign_private.record_readable(c,a.title_record_id))
  or (a.reference_record_id is not null and not campaign_private.record_readable(c,a.reference_record_id))
  or (a.perspective_record_id is not null and not campaign_private.record_readable(c,a.perspective_record_id))
  or (a.subject_relationship_id is not null and not campaign_private.relationship_readable(c,a.subject_relationship_id))
  or (a.subject_claim_id is not null and not campaign_private.claim_readable(c,a.subject_claim_id))
  or (a.subject_name_id is not null and not campaign_private.name_readable(c,a.subject_name_id))) then return false;end if;
 if i.title_record_id is not null and not campaign_private.record_readable(c,i.title_record_id) then return false;end if;
 if i.reference_record_id is not null and not campaign_private.record_readable(c,i.reference_record_id) then return false;end if;
 if i.perspective_record_id is not null and not campaign_private.record_readable(c,i.perspective_record_id) then return false;end if;
 if i.subject_relationship_id is not null and not campaign_private.relationship_readable(c,i.subject_relationship_id) then return false;end if;
 if i.subject_claim_id is not null and not campaign_private.claim_readable(c,i.subject_claim_id) then return false;end if;
 if i.subject_name_id is not null and not campaign_private.name_readable(c,i.subject_name_id) then return false;end if;
 return true;
end $$;
create function campaign_private.source_readable(c text,s text) returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.sources where campaign_id=c and id=s and campaign_private.can_read(c,audience,archived_at)
 and (note_record_id is null or campaign_private.record_readable(c,note_record_id)))
$$;
-- Only this fixed whitelist is accepted; never interpolate a client-provided table name.
create function campaign_private.row_readable(t text,c text,r text) returns boolean language plpgsql stable security definer set search_path='' as $$
declare allowed boolean;begin
 if t='records' then return campaign_private.record_readable(c,r);
 elsif t='sections' then return campaign_private.section_readable(c,r);
 elsif t='record_names' then return campaign_private.name_readable(c,r);
 elsif t='content_items' then return campaign_private.item_readable(c,r);
 elsif t='relationships' then return campaign_private.relationship_readable(c,r);
 elsif t='domain_claims' then return campaign_private.claim_readable(c,r);
 elsif t='sources' then return campaign_private.source_readable(c,r);
 elsif t='membership_implications' then
  return exists(select 1 from public.membership_implications where campaign_id=c and id=r and campaign_private.can_read(c,audience,archived_at) and campaign_private.record_readable(c,source_organization_id) and campaign_private.record_readable(c,target_organization_id));
 elsif t='power_definitions' then
  return exists(select 1 from public.power_definitions where campaign_id=c and power_record_id=r and campaign_private.record_readable(c,power_record_id) and campaign_private.record_readable(c,discipline_record_id));
 elsif t='item_references' then
  return exists(select 1 from public.item_references where campaign_id=c and id=r and campaign_private.can_read(c,audience,archived_at) and campaign_private.item_readable(c,item_id) and campaign_private.record_readable(c,target_record_id));
 elsif t='selected_powers' then
  return exists(select 1 from public.selected_powers where campaign_id=c and id=r and campaign_private.can_read(c,audience,archived_at) and campaign_private.item_readable(c,item_id) and campaign_private.record_readable(c,power_record_id) and campaign_private.record_readable(c,discipline_record_id));
 elsif t='person_status' then
  return exists(select 1 from public.person_status where campaign_id=c and id=r and campaign_private.can_read(c,audience,archived_at) and campaign_private.record_readable(c,person_record_id) and (session_record_id is null or campaign_private.record_readable(c,session_record_id)));
 elsif t='attachments' then
  return exists(select 1 from public.attachments where campaign_id=c and id=r and campaign_private.can_read(c,audience,archived_at) and campaign_private.record_readable(c,record_id) and (item_id is null or campaign_private.item_readable(c,item_id)));
 end if;
 return false;
end $$;
do $$ declare t text;begin
 foreach t in array campaign_private.mutable_tables() loop
  execute format('alter table public.%I enable row level security',t);
  execute format('create policy readable on public.%I for select using(campaign_private.row_readable(%L,campaign_id,id))',t,t);
  execute format('create policy storyteller_insert on public.%I for insert to authenticated with check(campaign_private.is_storyteller(campaign_id))',t);
  execute format('create policy storyteller_update on public.%I for update to authenticated using(campaign_private.is_storyteller(campaign_id)) with check(campaign_private.is_storyteller(campaign_id))',t);
  execute format('grant select on public.%I to anon,authenticated',t);
  execute format('grant insert,update on public.%I to authenticated',t);
 end loop;
end $$;
create policy shared_note_update on public.content_items for update to authenticated
 using(field_key='notes.player' and audience='players' and archived_at is null and campaign_private.is_member(campaign_id) and campaign_private.item_readable(campaign_id,id))
 with check(field_key='notes.player' and audience='players' and archived_at is null and campaign_private.is_member(campaign_id) and campaign_private.item_readable(campaign_id,id));
-- stamp_change additionally restricts player updates to body only. No INSERT/DELETE permission for players.
create policy powers_read on public.power_definitions for select using(campaign_private.record_readable(campaign_id,power_record_id) and campaign_private.record_readable(campaign_id,discipline_record_id));
create policy types_read on public.relationship_types for select using(campaign_private.is_member(campaign_id) or exists(select 1 from public.relationships where relationships.campaign_id=relationship_types.campaign_id and relationship_type=relationship_types.id));
create policy aliases_read on public.route_aliases for select using(campaign_private.is_member(campaign_id));
create policy issues_read on public.review_issues for select using(campaign_private.is_storyteller(campaign_id));
create policy proposals_read on public.change_proposals for select using(campaign_private.is_storyteller(campaign_id));
create policy history_read on public.change_events for select using(campaign_private.is_storyteller(campaign_id));
do $$ declare t text;begin
 foreach t in array array['power_definitions','relationship_types','route_aliases','review_issues','change_proposals'] loop
  execute format('alter table public.%I enable row level security',t);
  execute format('create policy storyteller_insert on public.%I for insert to authenticated with check(campaign_private.is_storyteller(campaign_id))',t);
  execute format('create policy storyteller_update on public.%I for update to authenticated using(campaign_private.is_storyteller(campaign_id)) with check(campaign_private.is_storyteller(campaign_id))',t);
  execute format('grant select on public.%I to authenticated',t);
  execute format('grant insert,update on public.%I to authenticated',t);
 end loop;
 foreach t in array array['power_definitions','relationship_types'] loop execute format('grant select on public.%I to anon',t);end loop;
 foreach t in array array['record_names','content_items','relationships','domain_claims','membership_implications','attachments','power_definitions'] loop
  execute format('create policy provenance_read on public.%I for select using(campaign_private.row_readable(%L,campaign_id,owner_id) and campaign_private.source_readable(campaign_id,source_id))',t||'_sources',t);
  execute format('create policy provenance_insert on public.%I for insert to authenticated with check(campaign_private.is_storyteller(campaign_id))',t||'_sources');
  execute format('create policy provenance_update on public.%I for update to authenticated using(campaign_private.is_storyteller(campaign_id)) with check(campaign_private.is_storyteller(campaign_id))',t||'_sources');
  execute format('grant select on public.%I to anon,authenticated',t||'_sources');
  execute format('grant insert,update on public.%I to authenticated',t||'_sources');
 end loop;
end $$;
alter table public.change_events enable row level security;
grant select on public.change_events to authenticated;
-- No browser role receives INSERT/UPDATE/DELETE on change_events or DELETE on campaign data.
-- Actual private media delivery, not merely hidden captions.
insert into storage.buckets(id,name,public) values('campaign-assets','campaign-assets',false);
create policy campaign_assets_read on storage.objects for select using(bucket_id='campaign-assets' and (
 campaign_private.is_storyteller(split_part(name,'/',1)) or exists(select 1 from public.attachments a where a.storage_bucket=objects.bucket_id and a.storage_path=objects.name)
));
create policy campaign_assets_insert on storage.objects for insert to authenticated with check(bucket_id='campaign-assets' and campaign_private.is_storyteller(split_part(name,'/',1)));
-- Updating an existing asset changes what an old path means. Prefer versioned uploads; no browser overwrite/delete yet.
revoke all on all functions in schema campaign_private from public;
grant execute on all functions in schema campaign_private to authenticated,anon;
-- Trigger functions are not callable as ordinary RPC operations; private schema is not an exposed API schema.

commit;
