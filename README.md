# PTPA AI Professional Development Survey

Web survey for the **Public Television Programmers Association Professional Development Committee** and its AI-focused webinars and professional-development sessions.

## Current event

**How AI is redefining the TV Programming Workflow**  
September 22, 2026 · 2:00 PM ET

Default event key:

`2026-09-22-ai-programming-workflow`

## Architecture

The site is a static GitHub Pages application connected directly to the WNMUProgramming Supabase project with a browser-safe Supabase publishable key.

All database objects for this application are deliberately PTPA-AI specific:

- `public.ptpa_ai_events`
- `public.ptpa_ai_responses`
- `ptpa_ai_*` indexes and RLS policies

No generic survey or response table names are used.

## Multiple PTPA-AI events

The database is designed for more than one AI event. Each session has its own row in `ptpa_ai_events`, including:

- event key
- event title
- start date/time
- timezone
- whether responses are still accepted
- whether group responses are publicly visible

Responses reference the event by `event_id`, keeping each session's answers separate.

The page uses the September 22 event by default. Another event can be selected with:

`?event=EVENT-KEY`

Example:

`index.html?event=2026-09-22-ai-programming-workflow`

## Response data

`ptpa_ai_responses` stores:

- optional name
- station / organization
- AI skill level
- webinar questions
- AI projects / experiments
- event ID
- submission timestamp

## Security

Row Level Security is enabled on both PTPA-AI tables.

For the current event:

- visitors may read event information
- visitors may submit a response only while the event is accepting responses
- visitors may read responses only when that event has `responses_public = true`
- visitors cannot update or delete responses

The frontend contains only the browser-safe Supabase publishable key. It does not contain a secret or service-role key.

## Empty-event examples

Until an event receives its first live response, the page displays six example responses so the Group Responses view is not empty. The page identifies them as examples. As soon as a live response exists for the event, only live Supabase responses are shown.

## Files

- `index.html` — live webinar survey and response viewer
- `supabase.sql` — PTPA-AI database schema, RLS policies, grants, indexes, and current event record
