import { supabase } from '$lib/supabase';

const siteUrl = 'https://www.your-domain.com'; // IMPORTANT: Replace with your actual domain

export async function GET() {
  // In a real application, you would fetch dynamic URLs (like products or blog posts)
  // from your database.
  // const { data: products } = await supabase.from('products').select('slug');
  // const { data: journalPosts } = await supabase.from('journal').select('slug');

  const staticPages = [
    '/',
    '/products',
    '/our-story',
    '/journal',
    '/contact',
    '/cart',
    '/checkout',
    '/login',
    '/privacy-policy',
    '/terms-of-service',
  ];

  const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  ${staticPages.map(page => `
  <url>
    <loc>${siteUrl}${page}</loc>
    <lastmod>${new Date().toISOString()}</lastmod>
    <priority>${page === '/' ? '1.0' : '0.8'}</priority>
  </url>`).join('')}

  <!-- Example for dynamic product pages -->
  <!-- 
  ${products?.map(product => `
  <url>
    <loc>${siteUrl}/products/${product.slug}</loc>
    <lastmod>${new Date().toISOString()}</lastmod>
    <priority>0.9</priority>
  </url>`).join('') || ''}
  -->

</urlset>`;

  return new Response(sitemap, {
    headers: {
      'Content-Type': 'application/xml',
    },
  });
}
