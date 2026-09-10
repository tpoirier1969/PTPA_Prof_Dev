-- PTPA Professional Development Skills & Projects Survey
-- Run this in the Supabase SQL Editor.
-- Database objects are prefixed with ptpa_pd_ to avoid collisions.

create extension if not exists pgcrypto;

create table if not exists public.ptpa_pd_responses (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 120),
  station_organization text not null check (char_length(station_organization) between 1 and 160),
  skill_level text not null check (skill_level in ('Beginner','Comfortable','Advanced','Expert')),
  questions text,
  projects_done text,
  created_at timestamptz not null default now()
);

alter table public.ptpa_pd_responses enable row level security;

-- Public form submissions are allowed.
drop policy if exists "ptpa_pd_public_insert" on public.ptpa_pd_responses;
create policy "ptpa_pd_public_insert"
on public.ptpa_pd_responses
for insert
to anon, authenticated
with check (true);

-- Full response viewing requires an authenticated Supabase user.
drop policy if exists "ptpa_pd_authenticated_read" on public.ptpa_pd_responses;
create policy "ptpa_pd_authenticated_read"
on public.ptpa_pd_responses
for select
to authenticated
using (true);

create index if not exists ptpa_pd_responses_created_at_idx
  on public.ptpa_pd_responses (created_at desc);

create index if not exists ptpa_pd_responses_skill_level_idx
  on public.ptpa_pd_responses (skill_level);

-- OPTIONAL FICTIONAL SAMPLE DATA
-- Uncomment only if you want demo rows in the real Supabase table.
/*
insert into public.ptpa_pd_responses
(name, station_organization, skill_level, questions, projects_done)
values
('Jordan Lee','Great Lakes Public Media','Advanced',
 'How are stations creating useful AI guidelines without making the rules obsolete six months later?',
 'Built a lightweight program-description cleanup workflow and tested AI-assisted schedule copy.'),
('Maya Thompson','Prairie Public Television','Comfortable',
 'I''d like practical examples of automating repetitive programming tasks without needing a full IT project.',
 'Created shared acquisition trackers and rebuilt several internal planning spreadsheets.'),
('Chris Alvarez','Coastal Public Media','Beginner',
 'Where should someone start with AI tools, and what information should never be pasted into them?',
 'Mostly manual workflows so far. I''ve experimented with ChatGPT for email drafts and meeting summaries.');
*/
