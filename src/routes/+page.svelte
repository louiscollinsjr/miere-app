<script lang="ts">
  import { t } from 'svelte-i18n';
  import ProductList from '$lib/components/ProductList.svelte';
</script>

<svelte:head>
  <title>m'mmiere - {$t('common.tagline')}</title>
  <meta name="description" content={$t('common.metaDescription')} />
</svelte:head>

<!-- Hero Section -->
<div class="relative bg-white overflow-hidden">
  <div class="max-w-7xl mx-auto">
    <div class="relative z-10 pb-8 bg-white sm:pb-16 md:pb-20 lg:max-w-2xl lg:w-full lg:pb-28 xl:pb-32">
      <main class="mt-10 mx-auto max-w-7xl px-4 sm:mt-12 sm:px-6 md:mt-16 lg:mt-20 lg:px-8 xl:mt-28">
        <div class="sm:text-center lg:text-left">
          <h1 class="text-4xl tracking-tight font-extrabold text-gray-900 sm:text-5xl md:text-6xl">
            <span class="block xl:inline">{$t('home.welcomeTitle')}</span>
          </h1>
          <p class="mt-3 text-base text-gray-800 sm:mt-5 sm:text-lg sm:max-w-xs sm:mx-auto md:mt-5 md:text-sm lg:mx-0 font-quicksand font-bold">
            {$t('home.welcomeSubtitle')}
          </p>
          <div class="mt-5 sm:mt-8 sm:flex sm:justify-center lg:justify-start">
            <div class="rounded-full shadow">
              <a href="/our-honey" class="w-full flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-full text-white bg-black hover:bg-gray-800 md:py-2 md:text-sm md:px-6 font-inter">
                {$t('home.shopNowButton')}
              </a>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
  <div class="lg:absolute lg:inset-y-0 lg:right-0 lg:w-1/2">
    <!-- <img class="h-56 w-full object-cover sm:h-72 md:h-96 lg:w-full lg:h-full" src="https://images.unsplash.com/photo-1587049352851-8d4e89133924?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80" alt="Honey jars"> -->
  </div>
</div>


<!-- Featured Products Section -->
<div class="bg-white">
  <div class="mx-auto max-w-7xl px-4 py-16 sm:px-6 sm:py-24 lg:px-8">
    <div class="text-center mb-12">
      <h2 class="text-3xl font-extrabold tracking-tight text-gray-900 sm:text-2xl">{$t('home.featuredProducts')}</h2>
      <p class="mt-4 max-w-2xl mx-auto text-base text-gray-7 font-bold">{$t('home.featuredProductsSubtitle')}</p>
    </div>
    <ProductList limit={4} />
  </div>
</div>
