<script lang="ts">
  import { t } from 'svelte-i18n';
  import { addToCart } from '$lib/stores/cart';
  import { getProductImageUrl } from '$lib/supabase'; // We'll use this later

  export let product: {
    id: string;
    name_en: string;
    name_ro: string;
    description_en?: string | null;
    description_ro?: string | null;
    price: number;
    image_path?: string | null;
  };
  export let name: string;
  export let description: string | null = null;

  // Placeholder image if no image_path is provided
  const placeholderImage = 'https://via.placeholder.com/400x300.png?text=Miere+Delicioasa';
  $: imageUrl = product.image_path ? getProductImageUrl('product-images', product.image_path) : placeholderImage;

  function handleAddToCart() {
    addToCart({
      id: product.id,
      name: product.name,
      price: product.price,
      imageUrl: product.image_path || undefined, // Pass actual image path if available
    });
  }
</script>

<div class="bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden flex flex-col h-full">
  <a href={`/products/${product.id}`} class="block group">
    <div class="aspect-w-4 aspect-h-3 bg-gray-100 overflow-hidden">
      <img 
        src={imageUrl} 
        alt={product.name} 
        class="w-full h-full object-cover group-hover:opacity-80 transition-opacity duration-200"
      />
    </div>
    <div class="p-4 flex-grow">
      <h3 class="text-lg font-semibold text-gray-900 group-hover:text-black transition-colors truncate">
        {product.name}
      </h3>
      {#if product.description}
        <p class="text-sm text-gray-600 mt-1 line-clamp-2">
          {product.description}
        </p>
      {/if}
    </div>
  </a>
  <div class="p-4 border-t border-gray-200 mt-auto">
    <div class="flex items-center justify-between">
      <p class="text-xl font-bold text-gray-900">
        {product.price.toFixed(2)} RON
      </p>
      <button 
        on:click={handleAddToCart}
        class="px-4 py-2 bg-black text-white text-sm font-medium rounded-md hover:bg-gray-800 transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black"
      >
        {$t('common.addToCart')}
      </button>
    </div>
  </div>
</div>
