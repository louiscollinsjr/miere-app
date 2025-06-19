<script lang="ts">
  import { onMount, onDestroy } from 'svelte';
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  import { getLocale } from '$lib/i18n';
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);
  import ProductCard from '$lib/components/ProductCard.svelte';
  import { t } from 'svelte-i18n';

  export let limit: number | null = null;

  import type { Product } from '../../app.d';
  let products: Product[] = [];
  
  // Get current locale for dynamic field selection
  let locale = 'en';
  const unsubscribe = getLocale().subscribe(value => {
    locale = value;
  });

  let loading = true;
  let error: string | null = null;

  onMount(async () => {
    let query = supabase
      .from('mmm_products')
      .select(`
        id, created_at, name_en, name_ro, description_en, description_ro, 
        application_description_en, application_description_ro, price, stock_quantity, 
        image_path, icon_path, icon_title_en, icon_title_ro, is_active
      `)
      .order(locale === 'ro' ? 'name_ro' : 'name_en', { ascending: true });

    if (limit) {
      query = query.limit(limit);
    }

    const { data, error: fetchError } = await query;

    if (fetchError) {
      console.error('Error fetching products:', fetchError);
      error = $t('products.loadError');
    } else {
      products = data;
    }
    loading = false;
  });
  
  onDestroy(() => {
    if (unsubscribe) unsubscribe();
  });
</script>

{#if loading}
  <p class="text-center">{$t('common.loading')}...</p>
{:else if error}
  <p class="text-center text-red-600">{error}</p>
{:else if products.length === 0}
  <p class="text-center">{$t('products.noProducts')}</p>
{:else}
  <div class="grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 xl:gap-x-8">
    {#each products as product (product.id)}
      <ProductCard {product} />
    {/each}
  </div>
{/if}
