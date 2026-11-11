// Edge Function: avisa por e-mail a cada nova inscrição (via Resend).
// Segredos: supabase secrets set RESEND_API_KEY=... ; Webhook: Database > Webhooks > tabela regs, evento INSERT
Deno.serve(async (req) => {
  const { record } = await req.json();
  const d = record.data;
  await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: { Authorization: `Bearer ${Deno.env.get("RESEND_API_KEY")}`, "Content-Type": "application/json" },
    body: JSON.stringify({
      from: "Encontro de Casais <onboarding@resend.dev>",
      to: ["promessamedeiros.mf@gmail.com"],
      subject: `Nova inscrição ${d.num}`,
      text: `${d.h.n} e ${d.w.n}\nIgreja: ${d.f.church}\nPagamento: ${d.mod} · Total R$ ${d.total}\nTelefones: ${d.h.t} / ${d.w.t}`,
    }),
  });
  return new Response("ok");
});
