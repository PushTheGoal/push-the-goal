// 1. The July 2026 hack injected casino spam under /2026/07/17/. The old site answered those with
//    410 Gone so Google drops them; keep doing that.
// 2. Preview and dev addresses (*.pages.dev) are for Izi's review only: tell search engines to skip
//    them so they never compete with push-the-goal.com.
export async function onRequest({ request, next }) {
  const url = new URL(request.url);
  if (url.pathname.startsWith('/2026/07/17/')) {
    return new Response('Gone', { status: 410, headers: { 'content-type': 'text/plain', 'x-robots-tag': 'noindex' } });
  }
  const res = await next();
  if (url.hostname.endsWith('.pages.dev')) {
    const out = new Response(res.body, res);
    out.headers.set('X-Robots-Tag', 'noindex, nofollow');
    return out;
  }
  return res;
}
