-- PTPA-AI webinar survey schema
-- Database objects are intentionally prefixed ptpa_ai_ so this project remains
-- isolated from other applications in the shared WNMUProgramming Supabase project.

create table if not exists public.ptpa_ai_events (
  id uuid primary key default gen_random_uuid(),
  event_key text not null unique,
  title text not null,
  starts_at timestamptz not null,
  timezone text not null default 'America/New_York',
  accepting_responses boolean not null default true,
  responses_public boolean not null default true,
  created_at timestamptz not null default now(),
  constraint ptpa_ai_events_event_key_check check (event_key ~ '^[a-z0-9][a-z0-9-]*$')
);

create table if not exists public.ptpa_ai_responses (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references public.ptpa_ai_events(id) on delete restrict,
  name text,
  station_organization text not null,
  skill_level text not null,
  webinar_questions text,
  ai_projects text,
  created_at timestamptz not null default now(),
  constraint ptpa_ai_responses_name_check check (name is null or char_length(trim(name)) between 1 and 120),
  constraint ptpa_ai_responses_station_check check (char_length(trim(station_organization)) between 1 and 160),
  constraint ptpa_ai_responses_skill_check check (skill_level in ('Beginner','Comfortable','Advanced','Expert')),
  constraint ptpa_ai_responses_questions_check check (webinar_questions is null or char_length(webinar_questions) <= 8000),
  constraint ptpa_ai_responses_projects_check check (ai_projects is null or char_length(ai_projects) <= 8000)
);

create index if not exists ptpa_ai_responses_event_created_idx
  on public.ptpa_ai_responses(event_id, created_at desc);

create index if not exists ptpa_ai_responses_event_skill_idx
  on public.ptpa_ai_responses(event_id, skill_level);

alter table public.ptpa_ai_events enable row level security;
alter table public.ptpa_ai_responses enable row level security;

-- Explicit Data API grants. This is required by current Supabase security defaults.
revoke all on table public.ptpa_ai_events from anon, authenticated;
revoke all on table public.ptpa_ai_responses from anon, authenticated;

grant select on table public.ptpa_ai_events to anon, authenticated;
grant select, insert on table public.ptpa_ai_responses to anon, authenticated;
grant select, insert, update, delete on table public.ptpa_ai_events to service_role;
grant select, insert, update, delete on table public.ptpa_ai_responses to service_role;

drop policy if exists "ptpa_ai_events_public_read" on public.ptpa_ai_events;
create policy "ptpa_ai_events_public_read"
on public.ptpa_ai_events
for select
to anon, authenticated
using (true);

drop policy if exists "ptpa_ai_responses_submit_to_open_event" on public.ptpa_ai_responses;
create policy "ptpa_ai_responses_submit_to_open_event"
on public.ptpa_ai_responses
for insert
to anon, authenticated
with check (
  exists (
    select 1
    from public.ptpa_ai_events e
    where e.id = event_id
      and e.accepting_responses = true
  )
);

drop policy if exists "ptpa_ai_responses_public_read_when_event_allows" on public.ptpa_ai_responses;
create policy "ptpa_ai_responses_public_read_when_event_allows"
on public.ptpa_ai_responses
for select
to anon, authenticated
using (
  exists (
    select 1
    from public.ptpa_ai_events e
    where e.id = event_id
      and e.responses_public = true
  )
);

-- Current webinar. Future PTPA-AI sessions get their own event_key and date,
-- while continuing to use the same ptpa_ai_responses table.
insert into public.ptpa_ai_events (
  event_key,
  title,
  starts_at,
  timezone,
  accepting_responses,
  responses_public
) values (
  '2026-09-22-ai-programming-workflow',
  'How AI is redefining the TV Programming Workflow',
  '2026-09-22 14:00:00-04'::timestamptz,
  'America/New_York',
  true,
  true
)
on conflict (event_key) do update set
  title = excluded.title,
  starts_at = excluded.starts_at,
  timezone = excluded.timezone;
