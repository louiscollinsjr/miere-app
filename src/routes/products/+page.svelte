<script lang="ts">
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);
  import ProductCard from '$lib/components/ProductCard.svelte';
  import { onMount } from 'svelte';
  import { t } from 'svelte-i18n';

  type Product = {
    id: string;
    created_at: string;
    name_en: string;
    name_ro: string;
    description_en?: string | null;
    description_ro?: string | null;
    price: number;
    stock_quantity: number;
    image_path?: string | null;
    is_active: boolean;
  };

  let products: Product[] = [];
  let loading = true;
  let error: string | null = null;

  onMount(async () => {
    try {
      const { data, error: dbError } = await supabase
        .from('mmm_products')
        .select('*')
        .eq('is_active', true)
        .order('created_at', { ascending: false });

      if (dbError) throw dbError;
      products = data || [];
    } catch (err: any) {
      console.error('Error fetching products:', err);
      error = err.message || 'Failed to load products.';
    } finally {
      loading = false;
    }
  });
</script>

<svelte:head>
  <title>{$t('nav.ourHoney')} - m'mmiere</title>
</svelte:head>

<div class="container mx-auto py-8">
  <h1 class="text-3xl font-bold mb-8 text-center">{$t('nav.ourHoney')}</h1>

  {#if loading}
    <p class="text-center text-gray-600">{$t('common.loading')}</p>
  {:else if error}
    <p class="text-center text-red-600">{error}</p>
  {:else if products.length === 0}
    <p class="text-center text-gray-600">No products available at the moment. Please check back soon!</p>
  {:else}
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      {#each products as product (product.id)}
        <ProductCard {product} />
      {/each}
    </div>
  {/if}
</div>
