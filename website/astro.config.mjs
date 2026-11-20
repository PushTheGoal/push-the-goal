// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

const noindex = ['/thank-you/'];

export default defineConfig({
  site: 'https://push-the-goal.com',
  // WordPress served every URL with a trailing slash; keep them identical so rankings carry over.
  trailingSlash: 'always',
  integrations: [sitemap({ filter: (page) => !noindex.some((p) => page.endsWith(p)) })],
});
