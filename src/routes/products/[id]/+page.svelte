<script lang="ts">
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { t } from 'svelte-i18n';
  import { getProductImageUrl } from '$lib/supabase';
  import { addToCart } from '$lib/stores/cart';

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

  let product: Product | null = null;
  let loading = true;
  let error: string | null = null;
  let imageUrl: string | null = null;
  const placeholderImage = 'https://via.placeholder.com/600x400.png?text=Miere+Delicioasa';

  onMount(async () => {
    const productId = $page.params.id;
    if (!productId) {
      error = 'Product ID is missing.';
      loading = false;
      return;
    }

    try {
      const { data, error: dbError } = await supabase
        .from('mmm_products')
        .select('*')
        .eq('id', productId)
        .eq('is_active', true)
        .single();

      if (dbError && dbError.code !== 'PGRST116') { // PGRST116: no rows found, which is a valid case for not found
        throw dbError;
      }
      
      if (!data) {
        error = 'Product not found or not available.';
      } else {
        product = data;
        if (product && product.image_path) {
          imageUrl = getProductImageUrl('product-images', product.image_path);
        } else {
          imageUrl = placeholderImage;
        }
      }
    } catch (err: any) {
      console.error('Error fetching product:', err);
      error = err.message || 'Failed to load product details.';
    } finally {
      loading = false;
    }
  });

  function handleAddToCart() {
    if (product) {
      addToCart({
        id: product.id,
        name: product.name,
        price: product.price,
        imageUrl: product.image_path || undefined,
      });
    }
  }
</script>

{#if loading}
  <div class="container mx-auto py-12 px-4 text-center">
    <p class="text-gray-600">{$t('common.loading')}</p>
  </div>
{:else if error || !product}
  <div class="container mx-auto py-12 px-4 text-center">
    <svelte:head>
      <title>{$t('productDetail.notFound')} - m'mmiere</title>
    </svelte:head>
    <p class="text-red-600 text-xl">{error || $t('productDetail.notFound')}</p>
    <a href="/products" class="mt-4 inline-block text-black hover:underline">{$t('productDetail.backToProducts')}</a>
  </div>
{:else}
  <svelte:head>
    <title>{product.name} - m'mmiere</title>
    {#if product.description}
      <meta name="description" content={product.description.substring(0, 160)} />
    {/if}
  </svelte:head>
  <div class="container mx-auto py-8 px-4">
    <div class="md:flex md:space-x-8">
      <div class="md:w-1/2 mb-6 md:mb-0">
        <div class="aspect-w-1 aspect-h-1 bg-gray-100 rounded-lg overflow-hidden shadow-lg">
          <img 
            src={imageUrl || placeholderImage} 
            alt={product.name} 
            class="w-full h-full object-cover"
            on:error={() => { imageUrl = placeholderImage; /* Fallback if Supabase image fails to load */ }}
          />
        </div>
      </div>
      <div class="md:w-1/2">
        <h1 class="text-3xl md:text-4xl font-bold mb-3">{product.name}</h1>
        <p class="text-2xl font-semibold text-gray-800 mb-6">{product.price.toFixed(2)} RON</p>
        
        {#if product.description}
          <div class="prose prose-sm sm:prose lg:prose-lg xl:prose-xl max-w-none mb-6">
            {@html product.description} <!-- Assuming description might contain basic HTML like paragraphs -->
          </div>
        {/if}

        <button 
          on:click={handleAddToCart}
          class="w-full md:w-auto px-8 py-3 bg-black text-white text-base font-medium rounded-md hover:bg-gray-800 transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black"
        >
          {$t('common.addToCart')}
        </button>

        <!-- Placeholder for stock information if needed later -->
        <!-- {#if product.stock_quantity < 10 && product.stock_quantity > 0}
          <p class="text-sm text-yellow-600 mt-2">{$t('productDetail.lowStock', { count: product.stock_quantity })}</p>
        {:else if product.stock_quantity <= 0}
          <p class="text-sm text-red-600 mt-2">{$t('productDetail.outOfStock')}</p>
        {/if} -->
      </div>
    </div>

    <!-- Suggested products or more details can go here -->
  </div>
{/if}
