<script lang="ts">
  import { t } from 'svelte-i18n';
  import ProductList from '$lib/components/ProductList.svelte';
</script>

<svelte:head>
  <title>{$t('nav.ourHoney')} - m'mmiere</title>
  <meta name="description" content={$t('ourHoney.metaDescription')} />
</svelte:head>

<div class="bg-white">
  <div class="mx-auto max-w-7xl px-4 py-16 sm:px-6 sm:py-24 lg:px-8">
    <div class="text-center mb-12">
      <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl">{$t('nav.ourHoney')}</h1>
      <p class="mt-4 max-w-2xl mx-auto text-lg text-gray-600">{$t('ourHoney.philosophy')}</p>
    </div>

    <ProductList />
  </div>
</div>
