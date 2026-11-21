// /blog-queue.json: what this build published and what is waiting for its date. WordPress answered
// this over /wp-json/; a static site has no API, so the build states it here. Gem's daily digest and
// blog watch and the Command Central dashboard read it. Same shape as the other static client sites
// (Hearthstone, Elite Concrete): generated, host, engine, published, scheduled, counts.
//
// The file is a snapshot of the live build. A post in "scheduled" whose time has passed means no
// rebuild has run since, so the daily "Website Deploy" rebuild has stopped: readers treat that as overdue.
import { getCollection } from 'astro:content';

export async function GET() {
  const now = new Date();
  const posts = (await getCollection('blog', (p) => !p.data.draft)).sort((a, b) => +a.data.date - +b.data.date);
  const row = (p: (typeof posts)[number]) => ({
    slug: p.id,
    title: p.data.title,
    date: p.data.date.toLocaleDateString('en-CA', { timeZone: 'America/New_York' }),
    datetime: p.data.date.toISOString(),
    link: `https://push-the-goal.com/${p.id}/`,
    category: p.data.category,
  });
  const published = posts.filter((p) => p.data.date <= now).reverse().map(row);
  const scheduled = posts.filter((p) => p.data.date > now).map(row);
  const body = {
    generated: now.toISOString(),
    host: 'push-the-goal.com',
    engine: 'astro-static',
    published: published.slice(0, 40),
    scheduled,
    counts: { published_total: published.length, scheduled: scheduled.length },
  };
  return new Response(JSON.stringify(body, null, 2) + '\n', {
    headers: { 'content-type': 'application/json; charset=utf-8' },
  });
}
