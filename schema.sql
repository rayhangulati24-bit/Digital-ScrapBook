-- Run this once in Supabase: SQL Editor > New query > paste > Run.
-- BEFORE running, replace the two example emails at the bottom with yours.

create table if not exists pages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  position int not null default 0
);

create table if not exists items (
  id uuid primary key default gen_random_uuid(),
  page uuid references pages(id) on delete cascade,
  type text not null,
  x double precision default 40,
  y double precision default 40,
  r double precision default 0,
  z int default 0,
  text text,
  img_path text,
  k text,
  blue boolean default false,
  created_by uuid default auth.uid(),
  created_at timestamptz default now()
);

create table if not exists settings (
  key text primary key,
  value text
);

-- Only these two emails may use the scrapbook.
create table if not exists allowed_emails (email text primary key);

create or replace function is_member() returns boolean
language sql security definer set search_path = public stable as $$
  select exists (
    select 1 from allowed_emails
    where lower(email) = lower(auth.jwt() ->> 'email')
  );
$$;

alter table pages enable row level security;
alter table items enable row level security;
alter table settings enable row level security;
alter table allowed_emails enable row level security; -- no policies = nobody can read it from the site

create policy "members only" on pages for all using (is_member()) with check (is_member());
create policy "members only" on items for all using (is_member()) with check (is_member());
create policy "members only" on settings for all using (is_member()) with check (is_member());

-- Private photo storage
insert into storage.buckets (id, name, public) values ('photos', 'photos', false)
on conflict (id) do nothing;

create policy "members read photos" on storage.objects for select
  using (bucket_id = 'photos' and is_member());
create policy "members add photos" on storage.objects for insert
  with check (bucket_id = 'photos' and is_member());
create policy "members delete photos" on storage.objects for delete
  using (bucket_id = 'photos' and is_member());

-- Live updates
alter publication supabase_realtime add table pages, items, settings;

-- >>> EDIT THESE TWO EMAILS (must match the accounts you create) <<<
insert into allowed_emails (email) values
  ('you@example.com'),
  ('partner@example.com')
on conflict do nothing;
