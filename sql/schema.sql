-- ===== Supabase Schema for Weekly Evaluation App =====
-- Run in Supabase SQL Editor (in order).

-- 1. Profiles
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique not null,
  display_name text not null,
  role text not null check (role in ('evaluator','viewer')),
  evaluator_key text check (evaluator_key in ('father','brother','doctor')),
  bio text default '',
  avatar text default '👤',
  settings jsonb default '{}'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.profiles add column if not exists bio text default '';
alter table public.profiles add column if not exists avatar text default '👤';
alter table public.profiles add column if not exists settings jsonb default '{}'::jsonb;
alter table public.profiles add column if not exists updated_at timestamptz default now();

alter table public.profiles enable row level security;

create policy "profiles_select_own_or_viewer" on public.profiles
  for select using (
    auth.uid() = id
    or exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'viewer')
  );

create policy "profiles_insert_own" on public.profiles
  for insert with check (auth.uid() = id);

create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id);

-- 2. Evaluations
create table if not exists public.evaluations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  evaluator_key text not null check (evaluator_key in ('father','brother','doctor')),
  eval_date date not null,
  positives text not null default '',
  negatives text not null default '',
  score numeric(3,1) not null check (score >= 0 and score <= 10),
  tags text[] default '{}',
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (user_id, eval_date)
);

alter table public.evaluations add column if not exists tags text[] default '{}';

alter table public.evaluations enable row level security;

create policy "evals_select_own_or_viewer" on public.evaluations
  for select using (
    auth.uid() = user_id
    or exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'viewer')
  );

create policy "evals_insert_own_evaluator" on public.evaluations
  for insert with check (
    auth.uid() = user_id
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'evaluator' and p.evaluator_key = evaluations.evaluator_key)
  );

create policy "evals_update_own" on public.evaluations
  for update using (auth.uid() = user_id);

-- 3. Comments (viewer feedback on evaluations)
create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  evaluation_id uuid not null references public.evaluations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  content text not null,
  created_at timestamptz default now()
);

alter table public.comments enable row level security;

create policy "comments_select_all_auth" on public.comments
  for select using (auth.uid() is not null);

create policy "comments_insert_viewer" on public.comments
  for insert with check (
    auth.uid() = user_id
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'viewer')
  );

create policy "comments_delete_own" on public.comments
  for delete using (auth.uid() = user_id);

-- 4. Goals
create table if not exists public.goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  target_score numeric(3,1) not null check (target_score >= 0 and target_score <= 10),
  week_start date not null,
  created_at timestamptz default now(),
  unique (user_id, week_start)
);

alter table public.goals enable row level security;

create policy "goals_select_own_or_viewer" on public.goals
  for select using (
    auth.uid() = user_id
    or exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'viewer')
  );

create policy "goals_insert_own" on public.goals
  for insert with check (auth.uid() = user_id);

create policy "goals_update_own" on public.goals
  for update using (auth.uid() = user_id);

-- 5. Auto-update updated_at
create or replace function public.touch_updated_at()
returns trigger as $$
begin new.updated_at = now(); return new; end;
$$ language plpgsql;

drop trigger if exists trg_evals_touch on public.evaluations;
create trigger trg_evals_touch before update on public.evaluations
  for each row execute function public.touch_updated_at();

drop trigger if exists trg_profiles_touch on public.profiles;
create trigger trg_profiles_touch before update on public.profiles
  for each row execute function public.touch_updated_at();

-- 6. Registration is done via the app (any username allowed).
