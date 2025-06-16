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

  // Compute the page title reactively based on error/product
  $: pageTitle = error || !product
    ? `${$t('productDetail.notFound')} - m'mmiere`
    : product
      ? `${product.name} - m'mmiere`
      : "m'mmiere";

  // Compute meta description reactively
  $: metaDescription = product && product.description
    ? product.description.substring(0, 160)
    : null;

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
          imageUrl = getProductImageUrl('mmm_product_images', product.image_path);
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

  let count = 1;

  function increment() {
    count = count + 1;
  }
  function decrement() {
    if (count > 1) count = count - 1;
  }

  function handleAddToCart() {
    if (product) {
      addToCart({
        id: product.id,
        name: product.name_en,
        price: product.price,
        imageUrl: product.image_path || undefined,
        count
      });
    }
  }
</script>

<svelte:head>
  <title>{pageTitle}</title>
  {#if metaDescription}
    <meta name="description" content={metaDescription} />
  {/if}
</svelte:head>


{#if loading}
  <div class="container mx-auto py-12 px-4 text-center">
    <p class="text-gray-600">{$t('common.loading')}</p>
  </div>
{:else if error || !product}
  <div class="container mx-auto py-12 px-4 text-center">
    <p class="text-red-600 text-xl">{error || $t('productDetail.notFound')}</p>
    <a href="/products" class="mt-4 inline-block text-black hover:underline">{$t('productDetail.backToProducts')}</a>
  </div>
{:else}
  <div class="container mx-auto py-8 px-4">
    <div class="md:flex md:space-x-8">
      <div class="md:w-1/2 mb-6 md:mb-0">
        <div class="aspect-w-1 aspect-h-1 bg-gray-100 rounded-lg overflow-hidden shadow-none">
          <img 
            src={imageUrl || placeholderImage} 
            alt={product.name_en} 
            class="w-full h-full object-cover"
            on:error={() => { imageUrl = placeholderImage; /* Fallback if Supabase image fails to load */ }}
          />
        </div>
      </div>

      <div class="md:w-1/2">
        <p class="text-lg text-black font-bold font-dancing">m'mmiere</p>
        <h1 class="text-3xl md:text-4xl font-bold mb-3">{product.name_en}</h1>
        <p class="text-sm font-semibold text-gray-800 mb-6">{product.price.toFixed(2)} RON</p> <!-- TODO: Convert to EUR € $ -->
        
        <div class="flex flex-col items-left justify-center">
          <img 
            src="/acacia.png" 
            alt="Acacia" 
            class="w-12 h-12 object-cover"
          />
          <h1 class="text-xs font-bold my-3 mb-6">{product.name_en}</h1>
        </div>

        {#if product.description_en}
          <div class="prose font-bold prose-sm sm:prose lg:prose-sm xl:prose-sm max-w-none mb-6">
            {@html product.description_en}
            <p class="text-xs font-bold pt-16 w-[60%]">Application:</p>
            <p class="text-xs font-bold pt-2 w-[60%] leading-5">A gentle, light honey known for its soothing properties.
              Helps relieve fatigue and promotes restful sleep.
              Supports emotional balance and may assist in reducing mild anxiety.
              Contributes to stabilizing blood pressure and improving digestion.
              Its antimicrobial nature can aid in healing minor skin irritations and gastric discomfort, such as ulcers.</p>
          </div>
        {/if}

        <div class="flex items-center space-x-4 mb-4">
  <button on:click={decrement} class="w-8 h-8 rounded-full border border-gray-300 text-xl flex items-center justify-center text-gray-400 hover:text-black hover:border-black focus:outline-none">-</button>
  <span class="w-10 h-8 flex items-center justify-center rounded-full border border-gray-300 text-sm font-bold font-inter bg-white">{count}</span>
  <button on:click={increment} class="w-8 h-8 rounded-full border border-gray-300 text-xl flex items-center justify-center text-gray-400 hover:text-black hover:border-black focus:outline-none">+</button>
  <button 
    on:click={handleAddToCart}
    class="w-40 px-4 py-3 bg-black text-white text-xs font-bold rounded-full hover:bg-gray-800 transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black uppercase tracking-widest"
  >
    {$t('common.addToCart')}
  </button>
</div>
      </div>
    </div>
    <!-- Suggested products or more details can go here -->
  </div>
{/if}
