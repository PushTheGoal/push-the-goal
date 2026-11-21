// 1. The July 2026 hack injected casino spam under /2026/07/17/. The old site answered those with
//    410 Gone so Google drops them; keep doing that.
// 2. Preview and dev addresses (*.pages.dev) are for Izi's review only: tell search engines to skip
//    them so they never compete with push-the-goal.com.
// 3. One address for the site: www.push-the-goal.com 301s to push-the-goal.com (same path and query),
//    so Google, Analytics and shared links all use the address the canonical tags already name.
export async function onRequest({ request, next }) {
  const url = new URL(request.url);
  if (url.hostname === 'www.push-the-goal.com') {
    url.hostname = 'push-the-goal.com';
    return Response.redirect(url.toString(), 301);
  }
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
