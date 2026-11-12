-- Block Board database setup.
-- Run once in Supabase: SQL Editor → New query → paste this whole file → Run.
-- Safe to run again; it skips anything that already exists.

-- One row per patient/block entry. The full entry lives in `data`; `date` is copied out so each day loads fast.
create table if not exists public.blocks (
  id          text primary key,
  date        text not null,              -- YYYY-MM-DD
  data        jsonb not null,
  updated_at  timestamptz not null default now(),
  updated_by  uuid default auth.uid()
);
create index if not exists blocks_date_idx on public.blocks (date);

-- Plans the board has learned (surgery → blocks and syringes the team used).
create table if not exists public.learned (
  id          text primary key,
  data        jsonb not null,
  updated_at  timestamptz not null default now()
);

-- Only signed-in team members can read or change anything. Anonymous visitors see nothing.
-- (Newer Supabase projects don't grant table access automatically, so grant it to signed-in users explicitly.)
grant select, insert, update, delete on public.blocks, public.learned to authenticated;
revoke all on public.blocks, public.learned from anon;
alter table public.blocks  enable row level security;
alter table public.learned enable row level security;

do $$
begin
  if not exists (select 1 from pg_policies where tablename = 'blocks' and policyname = 'team reads blocks') then
    create policy "team reads blocks"   on public.blocks  for select to authenticated using (true);
    create policy "team adds blocks"    on public.blocks  for insert to authenticated with check (true);
    create policy "team edits blocks"   on public.blocks  for update to authenticated using (true) with check (true);
    create policy "team deletes blocks" on public.blocks  for delete to authenticated using (true);
  end if;
  if not exists (select 1 from pg_policies where tablename = 'learned' and policyname = 'team reads learned') then
    create policy "team reads learned"   on public.learned for select to authenticated using (true);
    create policy "team adds learned"    on public.learned for insert to authenticated with check (true);
    create policy "team edits learned"   on public.learned for update to authenticated using (true) with check (true);
    create policy "team deletes learned" on public.learned for delete to authenticated using (true);
  end if;
end $$;

-- Who may use the board: first name + last initial (e.g. "Jane D"). Kept here, not in the public code.
-- Add or remove people with supabase/team-members.sql, or in Table Editor → team_members.
create table if not exists public.team_members (
  name_key      text primary key,   -- lowercase, letters and single spaces only, e.g. 'jane d'
  display_name  text not null       -- as shown on the board, e.g. 'Jane D'
);
alter table public.team_members enable row level security;
grant select on public.team_members to authenticated;
revoke all on public.team_members from anon;
do $$
begin
  if not exists (select 1 from pg_policies where tablename = 'team_members' and policyname = 'team reads members') then
    create policy "team reads members" on public.team_members for select to authenticated using (true);
  end if;
end $$;

-- Live updates: send every change on these tables to everyone who has the board open.
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'blocks') then
    alter publication supabase_realtime add table public.blocks;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'learned') then
    alter publication supabase_realtime add table public.learned;
  end if;
end $$;
