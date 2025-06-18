<script lang="ts">
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);
  import ProductCard from '$lib/components/ProductCard.svelte';
  import { page } from '$app/stores';
  import { derived } from 'svelte/store';
  import { t } from 'svelte-i18n';

  import type { Product } from '../../app.d';

  let products: Product[] = [];
  let loading = true;
  let error: string | null = null;
  let query = '';

  // This derived store will react to changes in the URL's search parameters
  const searchQuery = derived(page, ($page: any) => $page.url.searchParams.get('q') || '');

  // We subscribe to the derived store. Whenever the search query in the URL changes,
  // this code will re-run to fetch new search results.
  searchQuery.subscribe(async (value: string) => {
    query = value.trim();
    if (!query) {
      products = [];
      loading = false;
      return;
    }

    loading = true;
    error = null;

    try {
      // Using .or() with .ilike for a case-insensitive search across both name and description.
      // For a more advanced search, you could set up pg_trgm or full-text search in Supabase.
      const { data, error: dbError } = await supabase
        .from('products')
        .select('*')
        .or(`name_en.ilike.%${query}%,description_en.ilike.%${query}%`)
        .eq('is_active', true);

      if (dbError) throw dbError;
      products = data || [];
    } catch (err: any) {
      console.error('Error fetching search results:', err);
      error = err.message || 'Failed to load search results.';
    } finally {
      loading = false;
    }
  });
</script>

<svelte:head>
  <title>{query ? $t('search.title', { values: { query } }) : 'Search'} - m'mmiere</title>
</svelte:head>

<div class="container mx-auto py-8 px-4">
  {#if query}
    <h1 class="text-3xl font-bold mb-8 text-center">
      {$t('search.resultsFor', { values: { query } })}
    </h1>
  {:else}
    <h1 class="text-3xl font-bold mb-8 text-center">
      {$t('search.prompt')}
    </h1>
  {/if}

  {#if loading}
    <p class="text-center text-gray-600">{$t('common.loading')}</p>
  {:else if error}
    <p class="text-center text-red-600">{error}</p>
  {:else if products.length === 0 && query}
    <p class="text-center text-gray-600">{$t('search.noResults', { values: { query } })}</p>
  {:else if products.length > 0}
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      {#each products as product (product.id)}
        <ProductCard {product} />
      {/each}
    </div>
  {/if}
</div>
