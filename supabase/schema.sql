-- Rode no Supabase: SQL Editor > New query > Run
create table regs(id text primary key, data jsonb not null, created_at timestamptz default now());
create table config(id text primary key, data jsonb not null);
alter table regs enable row level security;
alter table config enable row level security;
-- Visitantes só podem INSERIR inscrição (não leem nada). Duplicidade barrada pela chave id.
create policy "publico insere" on regs for insert to anon with check (true);
create policy "admin total" on regs for all to authenticated using (true) with check (true);
create policy "config leitura" on config for select to anon, authenticated using (true);
create policy "config admin" on config for all to authenticated using (true) with check (true);
-- Contador público de vagas (só o número, sem dados pessoais)
create function vagas() returns int language sql security definer set search_path=public as
$$ select count(*)::int from regs where coalesce(data->>'st','')<>'Cancelada' $$;
grant execute on function vagas() to anon, authenticated;
-- Limite de vagas aplicado no servidor
create function limite() returns trigger language plpgsql security definer set search_path=public as $$
declare m int;
begin
  select least(coalesce((data->>'rooms')::int,25),coalesce((data->>'maxCouples')::int,25)) into m from config where id='main';
  if m is null then m:=25; end if;
  if (select count(*) from regs where coalesce(data->>'st','')<>'Cancelada')>=m then raise exception 'Vagas esgotadas'; end if;
  return new;
end $$;
create trigger t_limite before insert on regs for each row execute function limite();
