<script lang="ts">
  import { t } from 'svelte-i18n';
  import { userStore } from '$lib/stores/user';
  import { cart, clearCart } from '$lib/stores/cart'; // Added clearCart
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY); // Import supabase client
  import { loadStripe, type Stripe } from '@stripe/stripe-js'; // Import Stripe

  let stripe: Stripe | null = null;
  let cardElement: any; // Placeholder for Stripe Card Element
  // It's crucial to use your actual publishable key
  const STRIPE_PUBLIC_KEY = 'pk_test_YOUR_STRIPE_PUBLISHABLE_KEY'; // Replace with your actual key

  let isAuthenticated = false;
  let email = '';
  let currentUserId: string | undefined;
  let paymentMethod: 'stripe' | 'cod' = 'stripe';
  let isProcessing = false;

  userStore.subscribe(value => {
    isAuthenticated = !!value.user;
    if (value.user) {
      email = value.user.email || '';
      currentUserId = value.user.id;
    } else {
      currentUserId = undefined;
    }
  });

  onMount(async () => {
    if ($cart.length === 0) {
      goto('/cart'); // Redirect to cart if it's empty
      return;
    }

    // Initialize Stripe.js
    stripe = await loadStripe(STRIPE_PUBLIC_KEY);
    if (stripe) {
      const elements = stripe.elements({
        // You can customize the appearance of the elements here
        // appearance: { theme: 'stripe' }
      });
      cardElement = elements.create('card', {
        style: {
          base: {
            color: '#32325d',
            fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
            fontSmoothing: 'antialiased',
            fontSize: '16px',
            '::placeholder': {
              color: '#aab7c4'
            }
          },
          invalid: {
            color: '#fa755a',
            iconColor: '#fa755a'
          }
        }
      });
      cardElement.mount('#card-element');
    } else {
      console.error('Failed to load Stripe.js');
    }
  });

  // Placeholder for form data and submission logic
  let shippingAddress = {
    fullName: '',
    addressLine1: '',
    addressLine2: '',
    city: '',
    postalCode: '',
    country: 'Romania', // Default or could be a select
    phoneNumber: ''
  };

  async function handleCheckout() {
    if (!isAuthenticated) {
      alert($t('checkout.loginRequired'));
      goto(`/login?redirect=/checkout`);
      return;
    }

    isProcessing = true;

    if (!currentUserId) {
      alert('User ID not found. Please ensure you are logged in.');
      isProcessing = false;
      return;
    }

    const orderTotal = $cart.reduce((sum, item) => sum + item.price * item.quantity, 0);

    try {
      let paymentSuccessful = false;
      let orderPayload: any = {
        user_id: currentUserId,
        total_amount: orderTotal,
        shipping_address: shippingAddress,
      };

      if (paymentMethod === 'stripe') {
        if (!stripe || !cardElement) {
          throw new Error('Stripe is not initialized properly.');
        }

        const response = await fetch('/api/create-payment-intent', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ amount: orderTotal })
        });
        const paymentIntentResult = await response.json();
        if (response.status !== 200) {
          throw new Error(paymentIntentResult.message || 'Failed to create payment intent.');
        }
        
        const { clientSecret } = paymentIntentResult;

        const { error: stripeError, paymentIntent } = await stripe.confirmCardPayment(
          clientSecret,
          {
            payment_method: {
              card: cardElement,
              billing_details: { name: shippingAddress.fullName, email: email },
            },
          }
        );
        if (stripeError) {
          throw new Error(`Payment failed: ${stripeError.message}`);
        }

        if (paymentIntent && paymentIntent.status === 'succeeded') {
          paymentSuccessful = true;
          orderPayload.status = 'paid';
          orderPayload.payment_method = 'stripe';
          orderPayload.stripe_payment_intent_id = paymentIntent.id;
        }
      } else { // Cash on Delivery
        paymentSuccessful = true;
        orderPayload.status = 'pending';
        orderPayload.payment_method = 'cod';
      }

      if (paymentSuccessful) {
        const { data: orderData, error: orderError } = await supabase
          .from('orders')
          .insert(orderPayload)
          .select('id')
          .single();

        if (orderError) throw orderError;

        const newOrderId = orderData.id;
        const orderItems = $cart.map(item => ({
          order_id: newOrderId,
          product_id: item.id,
          quantity: item.quantity,
          price: item.price,
        }));

        const { error: itemsError } = await supabase.from('order_items').insert(orderItems);

        if (itemsError) {
          alert('Your order was placed, but we encountered an issue recording the items. Please contact support.');
          throw itemsError;
        }

        clearCart();
        goto(`/checkout/success?order_id=${newOrderId}`);
      }
    } catch (error: any) {
      console.error('Checkout error:', error);
      alert(`Error during checkout: ${error.message || 'Please try again.'}`);
    } finally {
      isProcessing = false;
    }
  }

</script>

<svelte:head>
  <title>{$t('checkout.title')} - m'mmiere</title>
</svelte:head>

<div class="container mx-auto py-8 px-4 max-w-2xl">
  <h1 class="text-3xl font-bold mb-8 text-center">{$t('checkout.title')}</h1>

  {#if $cart.length === 0}
    <p class="text-center text-gray-600">{$t('checkout.emptyCartRedirect')}</p>
  {:else}
    <form on:submit|preventDefault={handleCheckout} class="space-y-6 bg-white p-6 md:p-8 rounded-lg shadow-md">
      
      <section>
        <h2 class="text-xl font-semibold mb-4 border-b pb-2">{$t('checkout.shippingAddress')}</h2>
        
        {#if !isAuthenticated}
          <div class="mb-4 p-3 bg-yellow-50 border border-yellow-300 rounded-md">
            <p class="text-sm text-yellow-700">{$t('checkout.guestPrompt')} <a href="/login?redirect=/checkout" class="font-medium hover:underline">{$t('nav.login')}</a> {$t('checkout.orContinueAsGuest')}</p>
          </div>
        {/if}

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label for="email" class="block text-sm font-medium text-gray-700">{$t('checkout.email')}</label>
            <input type="email" id="email" bind:value={email} required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-black focus:ring-black sm:text-sm p-2" disabled={isAuthenticated} />
          </div>
          <div>
            <label for="fullName" class="block text-sm font-medium text-gray-700">{$t('checkout.fullName')}</label>
            <input type="text" id="fullName" bind:value={shippingAddress.fullName} required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-black focus:ring-black sm:text-sm p-2" />
          </div>
        </div>

        <div class="mt-4">
          <label for="addressLine1" class="block text-sm font-medium text-gray-700">{$t('checkout.addressLine1')}</label>
          <input type="text" id="addressLine1" bind:value={shippingAddress.addressLine1} required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-black focus:ring-black sm:text-sm p-2" />
        </div>

        <div class="mt-4">
          <label for="addressLine2" class="block text-sm font-medium text-gray-700">{$t('checkout.addressLine2')} ({$t('common.optional')})</label>
          <input type="text" id="addressLine2" bind:value={shippingAddress.addressLine2} class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-black focus:ring-black sm:text-sm p-2" />
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
          <div>
            <label for="city" class="block text-sm font-medium text-gray-700">{$t('checkout.city')}</label>
            <input type="text" id="city" bind:value={shippingAddress.city} required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-black focus:ring-black sm:text-sm p-2" />
          </div>
          <div>
            <label for="postalCode" class="block text-sm font-medium text-gray-700">{$t('checkout.postalCode')}</label>
            <input type="text" id="postalCode" bind:value={shippingAddress.postalCode} required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-black focus:ring-black sm:text-sm p-2" />
          </div>
           <div>
            <label for="country" class="block text-sm font-medium text-gray-700">{$t('checkout.country')}</label>
            <input type="text" id="country" bind:value={shippingAddress.country} required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-black focus:ring-black sm:text-sm p-2 bg-gray-50" readonly />
          </div>
        </div>
         <div class="mt-4">
          <label for="phoneNumber" class="block text-sm font-medium text-gray-700">{$t('checkout.phoneNumber')}</label>
          <input type="tel" id="phoneNumber" bind:value={shippingAddress.phoneNumber} required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-black focus:ring-black sm:text-sm p-2" />
        </div>
      </section>

      <!-- Payment Method Selection -->
      <section>
        <h2 class="text-xl font-semibold mb-4 border-b pb-2">{$t('checkout.paymentMethod')}</h2>
        <div class="space-y-2">
          <label class="flex items-center p-3 border rounded-md has-[:checked]:bg-gray-50 has-[:checked]:border-black cursor-pointer">
            <input type="radio" name="paymentMethod" value="stripe" bind:group={paymentMethod} class="h-4 w-4 text-black border-gray-300 focus:ring-black">
            <span class="ml-3 font-medium text-gray-700">{$t('checkout.payWithCard')}</span>
          </label>
          <label class="flex items-center p-3 border rounded-md has-[:checked]:bg-gray-50 has-[:checked]:border-black cursor-pointer">
            <input type="radio" name="paymentMethod" value="cod" bind:group={paymentMethod} class="h-4 w-4 text-black border-gray-300 focus:ring-black">
            <span class="ml-3 font-medium text-gray-700">{$t('checkout.cashOnDelivery')}</span>
          </label>
        </div>
      </section>

      <!-- Payment Information -->
      {#if paymentMethod === 'stripe'}
      <section>
        <h2 class="text-xl font-semibold mb-4 border-b pb-2">{$t('checkout.paymentDetails')}</h2>
        <div id="card-element" class="p-3 border border-gray-300 rounded-md shadow-sm">{/* Stripe Card Element will be mounted here */}</div>
        <p class="text-xs text-gray-500 mt-2">{$t('checkout.stripeInfoPlaceholder')}</p>
        {#if !STRIPE_PUBLIC_KEY.startsWith('pk_test_') || STRIPE_PUBLIC_KEY === 'pk_test_YOUR_STRIPE_PUBLISHABLE_KEY'}
          <p class="text-sm text-red-600 mt-2"><strong>Warning:</strong> Stripe Publishable Key is not configured or is using the default placeholder. Please replace <code>pk_test_YOUR_STRIPE_PUBLISHABLE_KEY</code> in <code>src/routes/checkout/+page.svelte</code> with your actual Stripe publishable key.</p>
        {/if}
      </section>
      {/if}

      <button type="submit" class="w-full bg-black text-white py-3 px-4 rounded-md font-medium hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black transition-colors disabled:opacity-50"
        disabled={isProcessing || $cart.length === 0}
      >
        {#if isProcessing}
          {$t('common.processing')}...
        {:else}
          {$t('checkout.placeOrderButton')} ({$cart.reduce((sum, item) => sum + item.price * item.quantity, 0).toFixed(2)} RON)
        {/if}
      </button>
    </form>
  {/if}
</div>
