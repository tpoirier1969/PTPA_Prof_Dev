# PTPA Professional Development Skills & Projects Survey

A small static web app for the **Public Television Programmers Association Professional Development Committee**.

## What it does

- Collects a member's name and station/organization
- Asks for current skill level
- Collects questions/topics they want help with
- Collects projects they have already done
- Provides a group-response view with search and skill-level filtering
- Includes fictional sample data so the concept can be demonstrated immediately

## Mockup mode

Open `index.html` directly or publish the repository with GitHub Pages.

The current version is intentionally self-contained and runs without Supabase. Form submissions are added only to the current browser session. Refreshing the page restores the original fictional sample data.

## Supabase setup

Run `supabase.sql` in the Supabase SQL Editor.

The table is `public.ptpa_pd_responses`.

Security model in the supplied SQL:

- Anonymous/public visitors may insert responses.
- Only authenticated Supabase users may select/read the full response list.

## Next production step

Wire the page to Supabase, add committee/admin authentication for the full response view, and then remove mock mode/sample data.

## Files

- `index.html` — complete shareable mockup
- `supabase.sql` — database table, RLS policies, indexes, and optional sample inserts
