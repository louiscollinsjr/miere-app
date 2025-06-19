<script lang="ts">
  import { onMount } from 'svelte';
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  import { t } from 'svelte-i18n';
  import { getLocale } from '$lib/i18n';
  import PositiveEffects from './PositiveEffects.svelte';
  import { getProductImageUrl } from '$lib/supabase';
  import type { Product } from '../../app.d';
  
  // Get current locale for dynamic field selection
  let locale = 'en';
  const unsubscribe = getLocale().subscribe(value => {
    locale = value;
  });

  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);
  let products: Product[] = [];
  let loading = true;
  let error: string | null = null;

  onMount(async () => {
    const { data, error: fetchError } = await supabase
      .from('mmm_products')
      .select(`
        id, created_at, name_en, name_ro, description_en, description_ro, 
        application_description_en, application_description_ro, price, stock_quantity, 
        image_path, icon_path, icon_title_en, icon_title_ro, is_active,
        health_effects:mmm_product_effects(effect:mmm_health_effects(id, icon_name, label_en, label_ro))
      `)
      .order(locale === 'ro' ? 'name_ro' : 'name_en', { ascending: true });
    
    if (fetchError) {
      error = $t('products.loadError');
    } else {
      // Transform the nested health effects data structure
      products = data.map(product => ({
        ...product,
        health_effects: product.health_effects
          ? product.health_effects
              .map(pe => pe.effect)
              .filter(effect => effect !== null)
          : []
      }));
    }
    loading = false;
  });

  function getIconUrl(product: Product) {
    return product.icon_path
      ? getProductImageUrl('mmm_product_images', product.icon_path)
      : '/health_icons/drop.png';
  }
</script>

{#if loading}
  <p class="text-center">{$t('common.loading')}...</p>
{:else if error}
  <p class="text-center text-red-600">{error}</p>
{:else}
  <div class="space-y-16">
    {#each products as product (product.id)}
      <div class="flex flex-col items-center md:items-start gap-2 py-12 border-b border-gray-100 w-full">
        <img src={getIconUrl(product)} alt={locale === 'ro' && product.name_ro ? product.name_ro : product.name_en} class="w-12 h-12 object-cover rounded-lg mb-2" loading="lazy" />
        <p class="text-base font-bold font-quicksand text-center mt-2">{locale === 'ro' && product.icon_title_ro ? product.icon_title_ro : product.icon_title_en}</p>
        <!-- <h2 class="text-2xl font-bold mb-2 font-quicksand text-center md:text-left">{locale === 'ro' && product.name_ro ? product.name_ro : product.name_en}</h2> -->
        {#if (locale === 'ro' && product.description_ro) || product.description_en}
          <div class="text-sm text-gray-800 mb-2 text-center md:text-left font-quicksand font-bold">{@html locale === 'ro' && product.description_ro ? product.description_ro : product.description_en}</div>
        {/if}
        {#if (locale === 'ro' && product.application_description_ro) || product.application_description_en}
          <div class="mb-2 w-full font-quicksand font-bold">
            <span class="block text-sm font-bold text-gray-900 mt-2 mb-2">{$t('products.application')}:</span>
            <span class="block text-sm font-bold text-gray-900">{locale === 'ro' && product.application_description_ro ? product.application_description_ro : product.application_description_en}</span>
          </div>
        {/if}
        {#if product.health_effects && product.health_effects.length > 0}
          <div class="w-full my-6">
            <PositiveEffects effects={product.health_effects} heading="Positive Effects" />
          </div>
        {/if}
      </div>
    {/each}
  </div>
{/if}
