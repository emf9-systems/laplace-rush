-- Laplace Rush: pegar completo en Supabase → SQL Editor → Run (una sola vez).

-- Perfil público de cada jugador: lo que se ve en el ranking.
create table if not exists public.profiles (
  id uuid primary key references auth.users on delete cascade,
  username text unique not null check (username ~ '^[A-Za-z0-9_.-]{3,20}$'),
  xp integer not null default 0 check (xp between 0 and 5000000),
  lv integer not null default 1 check (lv between 1 and 1000),
  cards integer not null default 0 check (cards between 0 and 1000),
  streak integer not null default 0 check (streak between 0 and 100000),
  exam numeric(2,1) not null default 0 check (exam between 0 and 7),
  updated_at timestamptz not null default now()
);

-- Progreso completo (privado: cada uno ve solo el suyo).
create table if not exists public.progress (
  id uuid primary key references auth.users on delete cascade,
  save jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.progress enable row level security;

drop policy if exists "ranking publico" on public.profiles;
create policy "ranking publico" on public.profiles for select using (true);
drop policy if exists "editar mi perfil" on public.profiles;
create policy "editar mi perfil" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);
drop policy if exists "mi progreso" on public.progress;
create policy "mi progreso" on public.progress for all using (auth.uid() = id) with check (auth.uid() = id);

-- Nadie puede cambiarse el nombre de usuario ni crear perfiles a mano: solo se actualizan los puntajes.
revoke insert, update, delete on public.profiles from anon, authenticated;
grant update (xp, lv, cards, streak, exam, updated_at) on public.profiles to authenticated;
revoke all on public.progress from anon;

-- Al registrarse, se crea el perfil con el usuario elegido.
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, username) values (new.id, new.raw_user_meta_data ->> 'username');
  return new;
end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();
