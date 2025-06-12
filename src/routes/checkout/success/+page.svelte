<script lang="ts">
  import { page } from '$app/stores';
  import { t } from 'svelte-i18n';
  import { onMount } from 'svelte';
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);
  import { getProductImageUrl } from '$lib/supabase';

  let orderId: string | null = null;
  let order: any = null; // In a larger app, you'd define a type for this
  let isLoading = true;
  let error: string | null = null;
  const placeholderImage = 'https://via.placeholder.com/80x80.png?text=Miere';

  onMount(async () => {
    orderId = $page.url.searchParams.get('order_id');
    if (orderId) {
      const { data, error: fetchError } = await supabase
        .from('orders')
        .select(`
          id,
          created_at,
          total_amount,
          status,
          shipping_address,
          order_items (
            quantity,
            price_at_purchase,
            products (
              name,
              image_path
            )
          )
        `)
        .eq('id', orderId)
        .single();

      if (fetchError) {
        error = fetchError.message;
        console.error('Error fetching order details:', fetchError);
      } else {
        order = data;
      }
    } else {
      error = 'No order ID found in URL.';
    }
    isLoading = false;
  });

  function getDisplayImageUrl(itemImagePath: string | undefined): string {
    return itemImagePath ? getProductImageUrl('product-images', itemImagePath) : placeholderImage;
  }
</script>

<svelte:head>
  <title>{$t('checkout.success.title')} - m'mmiere</title>
</svelte:head>

<div class="container mx-auto py-12 px-4 max-w-3xl">
  {#if isLoading}
    <div class="text-center">
      <p class="text-lg">{$t('common.loading')}...</p>
    </div>
  {:else if error}
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg text-center" role="alert">
      <strong class="font-bold">{$t('checkout.success.errorTitle')}</strong>
      <p class="mt-2">{$t('checkout.success.errorMessage', { values: { error: error } })}</p>
    </div>
  {:else if order}
    <div class="bg-white p-6 md:p-8 rounded-lg shadow-lg">
      <div class="text-center mb-8">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-green-500 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <h1 class="text-3xl font-bold text-gray-900">{$t('checkout.success.header')}</h1>
        <p class="text-gray-600 mt-2">{$t('checkout.success.message')}</p>
      </div>

      <div class="border-t border-b border-gray-200 divide-y divide-gray-200">
        <div class="py-4 grid grid-cols-2 gap-4">
          <span class="font-semibold text-gray-700">{$t('checkout.success.orderId')}:</span>
          <span class="text-gray-800 break-all">{order.id}</span>
        </div>
        <div class="py-4 grid grid-cols-2 gap-4">
          <span class="font-semibold text-gray-700">{$t('checkout.success.orderDate')}:</span>
          <span class="text-gray-800">{new Date(order.created_at).toLocaleDateString($t('locale'), { year: 'numeric', month: 'long', day: 'numeric' })}</span>
        </div>
        <div class="py-4 grid grid-cols-2 gap-4">
          <span class="font-semibold text-gray-700">{$t('checkout.success.orderTotal')}:</span>
          <span class="font-bold text-gray-900">{order.total_amount.toFixed(2)} RON</span>
        </div>
      </div>

      <div class="mt-8">
        <h2 class="text-xl font-semibold mb-4 text-gray-800">{$t('checkout.success.itemsOrdered')}</h2>
        <ul class="space-y-4">
          {#each order.order_items as item}
            <li class="flex items-center space-x-4">
              <img 
                src={getDisplayImageUrl(item.products.image_path)}
                alt={item.products.name} 
                class="w-16 h-16 object-cover rounded-md border border-gray-200"
                on:error={(e) => { (e.target as HTMLImageElement).src = placeholderImage; }}
              />
              <div class="flex-grow">
                <p class="font-semibold text-gray-800">{item.products.name}</p>
                <p class="text-sm text-gray-600">{$t('checkout.success.quantity')}: {item.quantity}</p>
              </div>
              <p class="font-medium text-gray-800">{(item.price_at_purchase * item.quantity).toFixed(2)} RON</p>
            </li>
          {/each}
        </ul>
      </div>

      <div class="mt-8 border-t pt-6">
        <h2 class="text-xl font-semibold mb-4 text-gray-800">{$t('checkout.success.shippingTo')}</h2>
        <div class="text-gray-700 leading-relaxed">
          <p>{order.shipping_address.fullName}</p>
          <p>{order.shipping_address.addressLine1}</p>
          {#if order.shipping_address.addressLine2}
            <p>{order.shipping_address.addressLine2}</p>
          {/if}
          <p>{order.shipping_address.city}, {order.shipping_address.postalCode}</p>
          <p>{order.shipping_address.country}</p>
        </div>
      </div>
    </div>

    <div class="text-center mt-10">
      <a href="/products" class="bg-black text-white px-8 py-3 rounded-md font-medium hover:bg-gray-800 transition-colors">
        {$t('cart.continueShopping')}
      </a>
    </div>
  {:else}
    <div class="text-center">
      <p class="text-lg text-gray-600">{$t('checkout.success.noOrderFound')}</p>
    </div>
  {/if}
</div>
