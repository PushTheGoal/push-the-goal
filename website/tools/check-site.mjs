// Runs after `astro build`. Fails the build (so nothing deploys) when:
//   1. an address in tools/old-urls.txt is neither built nor redirected in public/_redirects
//      (every URL Google, the old sitemaps or the Wayback Machine knew; listings and rankings depend on them)
//   2. an internal link on any built page points at a page that does not exist
//   3. a built page carries an em dash or the word "actually" (house voice rules)
import { readFileSync, existsSync, readdirSync, statSync } from 'node:fs';
import { join } from 'node:path';

const dist = 'dist';
const problems = [];

const redirects = readFileSync('public/_redirects', 'utf8').split('\n')
  .map((l) => l.trim()).filter((l) => l && !l.startsWith('#')).map((l) => l.split(/\s+/)[0]);
const redirected = (p) => redirects.some((r) => (r.endsWith('*') ? p.startsWith(r.slice(0, -1)) : r === p));
const built = (p) => {
  const clean = decodeURI(p.split('#')[0].split('?')[0]);
  if (clean === '/' ) return existsSync(join(dist, 'index.html'));
  return existsSync(join(dist, clean, 'index.html')) || (existsSync(join(dist, clean)) && statSync(join(dist, clean)).isFile());
};

// 1. old URLs
const old = readFileSync('tools/old-urls.txt', 'utf8').split('\n').map((l) => l.trim()).filter((l) => l && !l.startsWith('#'));
for (const p of old) if (!built(p) && !redirected(p)) problems.push(`old URL dropped: ${p}`);

// 2 and 3. every built page
const pages = [];
(function walk(d) { for (const f of readdirSync(d)) { const p = join(d, f); statSync(p).isDirectory() ? walk(p) : p.endsWith('.html') && pages.push(p); } })(dist);
for (const file of pages) {
  const html = readFileSync(file, 'utf8');
  const page = '/' + file.slice(dist.length + 1).replace(/index\.html$/, '');
  const text = html.replace(/<script[\s\S]*?<\/script>|<style[\s\S]*?<\/style>/g, '').replace(/<[^>]+>/g, ' ');
  if (text.includes('—')) problems.push(`em dash on ${page}`);
  if (/\bactually\b/i.test(text)) problems.push(`"actually" on ${page}`);
  for (const [, href] of html.matchAll(/href="([^"]+)"/g)) {
    if (/^(https?:|mailto:|tel:|#|\/\/)/.test(href) || href.startsWith('/_astro/')) continue;
    const target = href.startsWith('/') ? href : null;
    if (target && !built(target) && !redirected(target)) problems.push(`broken link on ${page}: ${href}`);
  }
}

if (problems.length) {
  console.error(`\nSite check FAILED (${problems.length}):\n  ` + [...new Set(problems)].join('\n  '));
  process.exit(1);
}
console.log(`Site check passed: ${old.length} old URLs kept, ${pages.length} pages, internal links resolve, voice rules clean.`);
