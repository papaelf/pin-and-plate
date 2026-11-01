-- Pin & Plate cloud sync: run this once in your Supabase project (SQL Editor → New query → paste → Run).
-- It creates one table for your workouts and one private bucket for machine photos.
-- Row Level Security means each signed-in account can only ever see its own rows and files.

create table if not exists public.docs (
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  path text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  synced_at timestamptz not null default clock_timestamp(),
  primary key (user_id, path)
);

-- Stamp every write with the server time so phones can download only what changed.
create or replace function public.docs_touch() returns trigger
language plpgsql as $$
begin
  new.synced_at := clock_timestamp();
  return new;
end $$;

drop trigger if exists docs_touch on public.docs;
create trigger docs_touch before insert or update on public.docs
  for each row execute function public.docs_touch();

create index if not exists docs_user_synced on public.docs (user_id, synced_at);

alter table public.docs enable row level security;

drop policy if exists "own docs" on public.docs;
create policy "own docs" on public.docs
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

-- Private photo bucket; files live under <your user id>/...
insert into storage.buckets (id, name, public)
values ('photos', 'photos', false)
on conflict (id) do nothing;

drop policy if exists "own photos select" on storage.objects;
drop policy if exists "own photos insert" on storage.objects;
drop policy if exists "own photos update" on storage.objects;
drop policy if exists "own photos delete" on storage.objects;

create policy "own photos select" on storage.objects for select to authenticated
  using (bucket_id = 'photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "own photos insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "own photos update" on storage.objects for update to authenticated
  using (bucket_id = 'photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "own photos delete" on storage.objects for delete to authenticated
  using (bucket_id = 'photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
