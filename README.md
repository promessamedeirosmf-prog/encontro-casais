# Encontro de Casais 2027: Vercel + Supabase

## 1. Supabase (banco e login), grátis
1. Crie um projeto em supabase.com.
2. SQL Editor: cole e rode `supabase/schema.sql`.
3. Authentication > Providers > Email: **desligue "Allow new users to sign up"**.
4. Authentication > Users > Add user: crie o e-mail e a senha do administrador (e de quem mais da equipe precisar).
5. Project Settings > API: copie **Project URL** e **anon public key**.
6. Abra `index.html`, localize `SUPABASE_URL` e `SUPABASE_ANON_KEY` e cole os dois valores.

## 2. Vercel
- Opção A: coloque a pasta num repositório do GitHub; na Vercel, Add New > Project > Import (sem build, "Framework: Other").
- Opção B: `npm i -g vercel` e, dentro da pasta, rode `vercel --prod`.

Você recebe um endereço `https://NOME.vercel.app`.

## 3. Aviso por e-mail (opcional)
Crie conta no resend.com, gere a chave, rode `supabase functions deploy notify` e `supabase secrets set RESEND_API_KEY=...`.
Em Database > Webhooks, crie um webhook na tabela `regs` (evento INSERT) apontando para a função `notify`.
Sem domínio verificado no Resend, o envio só funciona para o e-mail dono da conta Resend.

## Segurança
- Visitantes só inserem inscrições; nada é lido sem login.
- Duplicidade (mesmos e-mails) e limite de vagas são barrados no servidor.
- Backup: Supabase > Database > Backups (e CSV no painel).
- WhatsApp automático não está incluído; os botões do painel continuam abrindo o WhatsApp com a mensagem pronta.
