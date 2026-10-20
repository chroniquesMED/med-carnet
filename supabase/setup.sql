-- MED — stockage partagé sécurisé pour Supabase
-- À exécuter une seule fois dans Supabase > SQL Editor.
-- Les données ne sont accessibles qu'aux utilisateurs connectés.
create table if not exists public.med_shared_state (
  id text primary key check (id = 'main'),
  state jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.med_shared_state enable row level security;

revoke all on public.med_shared_state from anon;
grant select, insert, update on public.med_shared_state to authenticated;

drop policy if exists "MED members can read shared state" on public.med_shared_state;
create policy "MED members can read shared state"
  on public.med_shared_state for select to authenticated
  using (true);

drop policy if exists "MED members can create shared state" on public.med_shared_state;
create policy "MED members can create shared state"
  on public.med_shared_state for insert to authenticated
  with check (id = 'main');

drop policy if exists "MED members can update shared state" on public.med_shared_state;
create policy "MED members can update shared state"
  on public.med_shared_state for update to authenticated
  using (id = 'main')
  with check (id = 'main');

-- Note : créez les comptes des membres dans Authentication avant de leur donner accès.
-- Ne désactivez pas RLS et ne partagez jamais une clé secret/service_role.
