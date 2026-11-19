// The July 2026 hack injected casino spam under /2026/07/17/. The old site answered those with
// 410 Gone so Google drops them; keep doing that. (A static 404 would also work, but 410 is faster.)
export async function onRequest({ request, next }) {
  const path = new URL(request.url).pathname;
  if (path.startsWith('/2026/07/17/')) {
    return new Response('Gone', { status: 410, headers: { 'content-type': 'text/plain', 'x-robots-tag': 'noindex' } });
  }
  return next();
}
