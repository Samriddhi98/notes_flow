-- Phase B: normalized schema for notes + tags + todos + media.
-- Run via Supabase dashboard SQL editor or `supabase db push`.
--
-- Existing state (assumed):
--   - public.notes (RLS on; policy "Users can manage their own notes": auth.uid() = user_id)
--   - public.notetags (empty stub; per-note tag — being replaced by user-level tags)
--   - public.note_images (empty stub — being replaced by note_media)

-- Drop empty stub tables that don't match the new normalized model.
drop table if exists public.notetags cascade;
drop table if exists public.note_images cascade;

-- Tighten notes columns (user_id, timestamps are non-null going forward).
alter table public.notes alter column user_id    set not null;
alter table public.notes alter column created_at set not null;
alter table public.notes alter column updated_at set not null;

------------------------------------------------------------
-- tags: user-level, reusable across notes
------------------------------------------------------------
create table public.tags (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (length(trim(name)) > 0),
  created_at timestamptz not null default now(),
  unique (user_id, name)
);
create index tags_user_id_idx on public.tags (user_id);
alter table public.tags enable row level security;
create policy "tags_owner_all" on public.tags
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

------------------------------------------------------------
-- note_tags: many-to-many between notes and tags
------------------------------------------------------------
create table public.note_tags (
  note_id uuid not null references public.notes(id) on delete cascade,
  tag_id  uuid not null references public.tags(id)  on delete cascade,
  primary key (note_id, tag_id)
);
create index note_tags_tag_id_idx on public.note_tags (tag_id);
alter table public.note_tags enable row level security;
create policy "note_tags_owner_all" on public.note_tags
  for all to authenticated
  using (
    exists (select 1 from public.notes n where n.id = note_tags.note_id and n.user_id = auth.uid())
    and exists (select 1 from public.tags  t where t.id = note_tags.tag_id  and t.user_id = auth.uid())
  )
  with check (
    exists (select 1 from public.notes n where n.id = note_tags.note_id and n.user_id = auth.uid())
    and exists (select 1 from public.tags  t where t.id = note_tags.tag_id  and t.user_id = auth.uid())
  );

------------------------------------------------------------
-- note_todos: checklist items per note
------------------------------------------------------------
create table public.note_todos (
  id uuid primary key default gen_random_uuid(),
  note_id uuid not null references public.notes(id) on delete cascade,
  text text not null default '',
  is_done boolean not null default false,
  position int not null default 0,
  created_at timestamptz not null default now()
);
create index note_todos_note_id_idx on public.note_todos (note_id);
alter table public.note_todos enable row level security;
create policy "note_todos_owner_all" on public.note_todos
  for all to authenticated
  using (exists (select 1 from public.notes n where n.id = note_todos.note_id and n.user_id = auth.uid()))
  with check (exists (select 1 from public.notes n where n.id = note_todos.note_id and n.user_id = auth.uid()));

------------------------------------------------------------
-- note_media: images + voice clips per note
------------------------------------------------------------
do $$
begin
  if not exists (select 1 from pg_type where typname = 'media_type') then
    create type media_type as enum ('image', 'voice');
  end if;
end$$;

create table public.note_media (
  id uuid primary key default gen_random_uuid(),
  note_id uuid not null references public.notes(id) on delete cascade,
  type media_type not null,
  storage_path text not null,
  duration_ms int,
  created_at timestamptz not null default now()
);
create index note_media_note_id_idx on public.note_media (note_id);
alter table public.note_media enable row level security;
create policy "note_media_owner_all" on public.note_media
  for all to authenticated
  using (exists (select 1 from public.notes n where n.id = note_media.note_id and n.user_id = auth.uid()))
  with check (exists (select 1 from public.notes n where n.id = note_media.note_id and n.user_id = auth.uid()));

------------------------------------------------------------
-- Storage bucket for media files.
-- Path convention: "<user_id>/<note_id>/<uuid>.<ext>"
------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('note_media', 'note_media', false)
on conflict (id) do nothing;

drop policy if exists "note_media_objects_select" on storage.objects;
drop policy if exists "note_media_objects_insert" on storage.objects;
drop policy if exists "note_media_objects_update" on storage.objects;
drop policy if exists "note_media_objects_delete" on storage.objects;

create policy "note_media_objects_select" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'note_media'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "note_media_objects_insert" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'note_media'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "note_media_objects_update" on storage.objects
  for update to authenticated
  using (
    bucket_id = 'note_media'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "note_media_objects_delete" on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'note_media'
    and (storage.foldername(name))[1] = auth.uid()::text
  );