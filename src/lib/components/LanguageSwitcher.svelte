<script lang="ts">
  import { getLocale, setLocale } from '$lib/i18n';
  import { t } from 'svelte-i18n';

  const currentLocale = getLocale();
  let showDropdown = false;

  const languages = [
    { code: 'en', name: 'English' },
    { code: 'ro', name: 'Română' },
  ];

  function switchLanguage(langCode: string) {
    setLocale(langCode);
    showDropdown = false;
  }

  function toggleDropdown() {
    showDropdown = !showDropdown;
  }
  
  // Close dropdown if clicked outside
  function handleClickOutside(event: MouseEvent) {
    const target = event.target as HTMLElement;
    if (target && !target.closest('.language-switcher-container')) {
      showDropdown = false;
    }
  }
</script>

<svelte:window on:click={handleClickOutside} />

<div class="relative language-switcher-container">
  <button 
    on:click={toggleDropdown} 
    class="flex items-center text-sm font-medium text-gray-700 hover:text-black transition-colors focus:outline-none"
    aria-haspopup="true"
    aria-expanded={showDropdown}
  >
    <span>{languages.find(l => l.code === $currentLocale)?.name || $currentLocale.toUpperCase()}</span>
    <svg class="ml-1 h-4 w-4 text-gray-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
    </svg>
  </button>

  {#if showDropdown}
    <div 
      class="absolute right-0 mt-2 w-36 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none z-10"
      role="menu"
      aria-orientation="vertical"
      aria-labelledby="menu-button"
    >
      <div class="py-1" role="none">
        {#each languages as lang}
          <button 
            on:click={() => switchLanguage(lang.code)} 
            class="w-full text-left px-4 py-2 text-sm {$currentLocale === lang.code ? 'font-semibold bg-gray-100 text-black' : 'text-gray-700 hover:bg-gray-100 hover:text-black'} transition-colors"
            role="menuitem"
            disabled={$currentLocale === lang.code}
          >
            {lang.name}
          </button>
        {/each}
      </div>
    </div>
  {/if}
</div>
