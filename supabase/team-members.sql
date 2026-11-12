-- Add people who may use the board. Run in Supabase: SQL Editor → New query → paste → Run.
-- One line per person: ('lowercase first name + last initial', 'As Shown').
-- Running it again is safe; existing names are just updated.
insert into public.team_members (name_key, display_name) values
  ('jane d', 'Jane D')
on conflict (name_key) do update set display_name = excluded.display_name;

-- To remove someone:
-- delete from public.team_members where name_key = 'jane d';

-- To see everyone on the list:
-- select display_name from public.team_members order by display_name;
