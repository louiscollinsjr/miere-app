<script lang="ts">
  import type { HealthEffect } from '../../app.d';
  import { getProductImageUrl } from '$lib/supabase';
  import { getLocale } from '$lib/i18n';
  import { t } from 'svelte-i18n';
  export let effects: HealthEffect[] = [];

  // Get current locale for dynamic field selection
  let locale = 'en';
  const unsubscribe = getLocale().subscribe(value => {
    locale = value;
  });

  // Generate Supabase icon URLs for each effect
  $: iconUrls = effects.map(effect =>
    effect.icon_name ? getProductImageUrl('mmm_product_images/health_icons', effect.icon_name.endsWith('.png') ? effect.icon_name : effect.icon_name + '.png') : 'drop.png'
  );
  let erroredIcons: boolean[] = [];
</script>

{#if effects.length > 0}
  <section class="">
  <h2 class="text-sm font-bold mb-4 text-quicksand">{$t('productDetail.positiveEffects')}:</h2>
  <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-4 gap-0.5 justify-start">
    {#each effects as effect, i (effect.id)}
      <div class="flex flex-col items-center text-center p-1 transition w-32">
        <img
          src={erroredIcons[i] ? '/health_icons/drop.png' : iconUrls[i]}
          alt={locale === 'ro' && effect.label_ro ? effect.label_ro : effect.label_en}
          class="w-8 h-8 mb-1"
          loading="lazy"
          on:error={() => erroredIcons[i] = true}
        />
        <span class="text-xs mt-1 font-quicksand font-bold">{locale === 'ro' && effect.label_ro ? effect.label_ro : effect.label_en}</span>
      </div>
    {/each}
  </div>
</section>
{/if}
