import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

export const CATEGORIES = ['Recruiting basics', 'Getting noticed', 'Divisions and money', 'For parents', 'Middle school'] as const;

const blog = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/blog' }),
  schema: ({ image }) => z.object({
    title: z.string(),
    seoTitle: z.string().max(70),
    description: z.string().max(170),
    category: z.enum(CATEGORIES),
    keyword: z.string().optional(),
    date: z.coerce.date(),
    image: image().optional(),
    draft: z.boolean().default(false),
  }),
});

const legal = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/legal' }),
  schema: z.object({ title: z.string(), description: z.string() }),
});

export const collections = { blog, legal };
