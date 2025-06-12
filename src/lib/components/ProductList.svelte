<script lang="ts">
  import { onMount } from 'svelte';
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);
  import ProductCard from '$lib/components/ProductCard.svelte';
  import { t } from 'svelte-i18n';

  export let limit: number | null = null;

  let products: any[] = [];
$: locale = $t('locale') || 'en'; // Use svelte-i18n locale
function getProductName(product) {
  return product[`name_${locale}`] || product.name_en || product.name;
}
function getProductDescription(product) {
  return product[`description_${locale}`] || product.description_en || product.description;
}
  let loading = true;
  let error: string | null = null;

  onMount(async () => {
    let query = supabase
      .from('mmm_products')
      .select('*')
      .order('name', { ascending: true });

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
      <ProductCard {product} name={getProductName(product)} description={getProductDescription(product)} />
    {/each}
  </div>
{/if}
