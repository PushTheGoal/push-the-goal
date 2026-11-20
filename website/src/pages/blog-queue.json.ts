// What Command Central, Gem's daily digest and the blog watch read in place of the WordPress API
// (same shape as the other static client sites).
import { getCollection } from 'astro:content';

export async function GET() {
  const now = new Date();
  const posts = await getCollection('blog', (p) => !p.data.draft);
  const row = (p: (typeof posts)[number]) => ({
    title: p.data.title, slug: p.id, url: `https://push-the-goal.com/${p.id}/`, date: p.data.date.toISOString(), category: p.data.category,
  });
  const published = posts.filter((p) => p.data.date <= now).sort((a, b) => +b.data.date - +a.data.date).map(row);
  const scheduled = posts.filter((p) => p.data.date > now).sort((a, b) => +a.data.date - +b.data.date).map(row);
  return new Response(JSON.stringify({ site: 'push-the-goal.com', built: now.toISOString(), published, scheduled }, null, 2), {
    headers: { 'content-type': 'application/json' },
  });
}
