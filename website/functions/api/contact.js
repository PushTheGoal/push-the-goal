// Contact form handler (Cloudflare Pages Function).
// Forwards each message to a GoHighLevel inbound webhook, so it lands in Izi's GHL as a contact.
// Settings on the Cloudflare Pages project: GHL_CONTACT_WEBHOOK (the inbound webhook URL from a NEW
// GHL workflow named "Claude - Website contact form"; existing GHL workflows are never edited).
export async function onRequestPost({ request, env }) {
  const form = await request.formData();
  if (form.get('website')) return Response.redirect(new URL('/thank-you/', request.url), 303); // bot trap
  const data = {
    athlete_name: (form.get('athlete') || '').toString().slice(0, 200),
    email: (form.get('email') || '').toString().slice(0, 200),
    phone: (form.get('phone') || '').toString().slice(0, 50),
    interested_in: (form.get('interest') || '').toString().slice(0, 100),
    message: (form.get('message') || '').toString().slice(0, 5000),
    source: 'push-the-goal.com contact form',
  };
  if (!data.email.includes('@')) return new Response('Please go back and add your email address.', { status: 400 });
  if (!env.GHL_CONTACT_WEBHOOK) return new Response('The contact form is not connected yet. Please email izi@push-the-goal.com.', { status: 503 });
  const r = await fetch(env.GHL_CONTACT_WEBHOOK, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(data) });
  if (!r.ok) return new Response('Something went wrong sending your message. Please email izi@push-the-goal.com.', { status: 502 });
  return Response.redirect(new URL('/thank-you/', request.url), 303);
}
