<script lang="ts">
  import { t } from 'svelte-i18n';
  import { getLocale } from '$lib/i18n';
  import { addToCart } from '$lib/stores/cart';
  import { getProductImageUrl } from '$lib/supabase';
  import { onDestroy } from 'svelte';

  import type { Product } from '../../app.d';
  export let product: Product;
  
  // Get current locale for dynamic field selection
  let locale = 'en';
  const unsubscribe = getLocale().subscribe(value => {
    locale = value;
    console.log('ProductCard - Current locale:', locale);
  });
  onDestroy(() => unsubscribe());

  // Placeholder image if no image_path is provided
  const placeholderImage = 'https://via.placeholder.com/400x300.png?text=Miere+Delicioasa';
  $: imageUrl = product.image_path ? getProductImageUrl('mmm_product_images', product.image_path) : placeholderImage;

  function handleAddToCart() {
    addToCart({
      id: product.id,
      name: locale === 'ro' && product.name_ro ? product.name_ro : product.name_en,
      price: product.price,
      imageUrl: product.image_path || undefined, // Pass actual image path if available
    });
  }
</script>

<div class="bg-white rounded-lg  overflow-hidden flex flex-col h-full">
  <a href={`/products/${product.id}`} class="block group text-center">
    <div class="aspect-w-4 aspect-h-3 bg-gray-100 overflow-hidden ">
      <img 
        src={imageUrl} 
        alt={locale === 'ro' && product.name_ro ? product.name_ro : product.name_en} 
        class="w-full h-full object-cover group-hover:opacity-80 transition-opacity duration-200"
      />
    </div>
    
    <div class="p-4 flex-grow">
      <h3 class="text-2xl font-semibold text-gray-900 group-hover:text-black transition-colors truncate">
        {locale === 'ro' && product.name_ro ? product.name_ro : product.name_en} 
      </h3>
      {#if (locale === 'ro' && product.description_ro) || product.description_en}
        <p class="text-sm text-gray-600 mt-1 line-clamp-2">
          {locale === 'ro' && product.description_ro ? product.description_ro : product.description_en}
        </p>
      {/if}
      <span class="text-gray-600 text-xs">450g</span>
    </div>
  </a>
  <div class="p-4 mt-auto">
    <div class="flex items-center justify-between">
      <p class="text-lg font-bold text-gray-900">
        {product.price.toFixed(2)} RON
      </p>
      <button 
        on:click={handleAddToCart}
        class="px-3 py-2 bg-black text-white font-inter text-xs font-bold rounded-full hover:bg-gray-800 transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black"
      >
        {$t('common.addToCart')}
      </button>
    </div>
  </div>
</div>
