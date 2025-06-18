<script lang="ts">
  import { t } from 'svelte-i18n';
  import ProductDetailsList from '$lib/components/ProductDetailsList.svelte';
</script>

<svelte:head>
  <title>{$t('nav.ourHoney')} - m'mmiere</title>
  <meta name="description" content={$t('ourHoney.metaDescription')} />
</svelte:head>

<div class="bg-white ">
  <div class="mx-auto max-w-2xl px-4 py-16 sm:px-6 sm:py-24 lg:px-8">
    <img src="/OurHoney.jpg" alt="Romanian honey jars and beekeeping" class="w-full  mb-24 object-cover max-h-96" />
    <div class="text-left mb-12">
      <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-3xl mb-8">{$t('nav.ourHoney')}</h1>
 <!-- introduction -->
      <p class="my-8 max-w-3xl text-2xl text-gray-600 font-quicksand font-bold ">{$t('ourHoney.philosophy')}</p>
      <p class="mt-4 max-w-3xl text-sm text-gray-800 font-quicksand font-bold">{$t('ourHoney.origin')}</p>
      <p class="mt-2 max-w-3xl text-sm text-gray-800 font-quicksand font-bold">{$t('ourHoney.character')}</p>
    </div>
    <ProductDetailsList /> 
  </div>
</div>
