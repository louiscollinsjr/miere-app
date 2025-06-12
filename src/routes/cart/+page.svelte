<script lang="ts">
  import { cart, removeFromCart, updateQuantity } from '$lib/stores/cart';
  import { t } from 'svelte-i18n';
  import { getProductImageUrl } from '$lib/supabase';
  import { goto } from '$app/navigation';

  const placeholderImage = 'https://via.placeholder.com/100x100.png?text=Miere';

  // Calculate total price
  $: totalPrice = $cart.reduce((sum, item) => sum + item.price * item.quantity, 0);

  function getDisplayImageUrl(itemImagePath: string | undefined): string {
    return itemImagePath ? getProductImageUrl('product-images', itemImagePath) : placeholderImage;
  }

  function incrementQuantity(itemId: string) {
    const item = $cart.find(i => i.id === itemId);
    if (item) {
      updateQuantity(itemId, item.quantity + 1);
    }
  }

  function decrementQuantity(itemId: string) {
    const item = $cart.find(i => i.id === itemId);
    if (item && item.quantity > 1) {
      updateQuantity(itemId, item.quantity - 1);
    } else if (item && item.quantity === 1) {
      // Optionally, confirm before removing or just remove
      removeFromCart(itemId);
    }
  }
</script>

<svelte:head>
  <title>{$t('cart.title')} - m'mmiere</title>
</svelte:head>

<div class="container mx-auto py-8 px-4">
  <h1 class="text-3xl font-bold mb-8 text-center">{$t('cart.title')}</h1>

  {#if $cart.length === 0}
    <div class="text-center py-12">
      <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-16 w-16 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
      </svg>
      <p class="mt-4 text-xl text-gray-600">{$t('cart.empty')}</p>
      <a href="/products" class="mt-6 inline-block bg-black text-white px-6 py-2 rounded-md font-medium hover:bg-gray-800 transition-colors">
        {$t('cart.continueShopping')}
      </a>
    </div>
  {:else}
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <div class="md:col-span-2 space-y-4">
        {#each $cart as item (item.id)}
          <div class="flex items-center bg-white p-4 border border-gray-200 rounded-lg shadow-sm">
            <img 
              src={getDisplayImageUrl(item.imageUrl)}
              alt={item.name} 
              class="w-20 h-20 object-cover rounded-md mr-4"
              on:error={(e) => { (e.target as HTMLImageElement).src = placeholderImage; }}
            />
            <div class="flex-grow">
              <a href={`/products/${item.id}`} class="text-lg font-semibold text-gray-900 hover:text-black transition-colors">{item.name}</a>
              <p class="text-sm text-gray-600">{item.price.toFixed(2)} RON</p>
            </div>
            <div class="flex items-center mx-4">
              <button 
                on:click={() => decrementQuantity(item.id)} 
                class="px-2 py-1 border border-gray-300 rounded-l-md text-gray-700 hover:bg-gray-100 transition-colors"
                aria-label={$t('cart.decreaseQuantity')}
              >−</button>
              <span class="px-3 py-1 border-t border-b border-gray-300 text-center w-12">{item.quantity}</span>
              <button 
                on:click={() => incrementQuantity(item.id)} 
                class="px-2 py-1 border border-gray-300 rounded-r-md text-gray-700 hover:bg-gray-100 transition-colors"
                aria-label={$t('cart.increaseQuantity')}
              >+</button>
            </div>
            <p class="text-md font-semibold w-24 text-right">{(item.price * item.quantity).toFixed(2)} RON</p>
            <button 
              on:click={() => removeFromCart(item.id)} 
              class="ml-4 text-gray-500 hover:text-red-600 transition-colors"
              aria-label={$t('cart.removeItem')}
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        {/each}
      </div>

      <div class="md:col-span-1">
        <div class="bg-white p-6 border border-gray-200 rounded-lg shadow-sm sticky top-20">
          <h2 class="text-xl font-semibold mb-4">{$t('cart.summary')}</h2>
          <div class="flex justify-between mb-2">
            <span>{$t('cart.subtotal')}</span>
            <span>{totalPrice.toFixed(2)} RON</span>
          </div>
          <div class="flex justify-between mb-2 text-gray-600 text-sm">
            <span>{$t('cart.shipping')}</span>
            <span>{$t('cart.shippingCalculated')}</span>
          </div>
          <hr class="my-4"/>
          <div class="flex justify-between font-bold text-lg mb-6">
            <span>{$t('cart.total')}</span>
            <span>{totalPrice.toFixed(2)} RON</span>
          </div>
          <button 
            on:click={() => goto('/checkout')} 
            class="w-full bg-black text-white py-3 rounded-md font-medium hover:bg-gray-800 transition-colors"
          >
            {$t('cart.proceedToCheckout')}
          </button>
        </div>
      </div>
    </div>
  {/if}
</div>
