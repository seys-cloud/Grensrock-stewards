-- ============================================================
-- Grensrock Steward Planner — Supabase setup
-- Project: xsavpdiupaxikzuqesul (zelfde als het draaiboek)
-- Datum: 2026-06-11
-- Plak dit één keer in: Supabase dashboard > SQL Editor > Run
-- ============================================================

-- 1) Tabel: één rij (id = 1) houdt de volledige planner-staat als JSON
--    (teams, posten, timetable én het gegenereerde/aangepaste rooster)
create table if not exists public.stewards_planner (
  id          integer primary key default 1,
  data        jsonb       not null default '{}'::jsonb,
  updated_at  timestamptz not null default now(),
  updated_by  text,
  constraint  stewards_planner_single_row check (id = 1)
);

-- 2) Zorg dat rij 1 bestaat (leeg) zodat de app er meteen kan op lezen/schrijven
insert into public.stewards_planner (id, data)
values (1, '{}'::jsonb)
on conflict (id) do nothing;

-- 3) Row Level Security aanzetten
alter table public.stewards_planner enable row level security;

-- 4a) PUBLIEK mag LEZEN  -> iedereen met de link ziet het rooster (read-only)
drop policy if exists "stewards public read" on public.stewards_planner;
create policy "stewards public read"
  on public.stewards_planner
  for select
  using (true);

-- 4b) Enkel INGELOGDE gebruikers mogen SCHRIJVEN (jij, via Supabase Auth login)
drop policy if exists "stewards auth update" on public.stewards_planner;
create policy "stewards auth update"
  on public.stewards_planner
  for update
  using (auth.uid() is not null)
  with check (auth.uid() is not null);

drop policy if exists "stewards auth insert" on public.stewards_planner;
create policy "stewards auth insert"
  on public.stewards_planner
  for insert
  with check (auth.uid() is not null);

-- 5) Realtime: live-sync tussen toestellen (tweede browser ziet wijzigingen meteen)
--    Negeer een eventuele "already member" fout — dan staat het er al.
alter publication supabase_realtime add table public.stewards_planner;

-- ============================================================
-- KLAAR. Login-gebruiker: hergebruik dezelfde e-mail+wachtwoord
-- die je voor de draaiboek-editor gebruikt (Auth > Users).
-- Bestaat die nog niet -> Auth > Users > Add user (email + password,
-- "Auto Confirm" aan).
-- ============================================================
