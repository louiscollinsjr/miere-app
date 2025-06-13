<script lang="ts">
  // Import dependencies
  import { cart } from '$lib/stores/cart'; // Shopping cart store
  import { userStore } from '$lib/stores/user'; // User authentication store
  import { createClient } from '@supabase/supabase-js'; // Supabase client
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public'; // Environment variables
  import { goto } from '$app/navigation'; // Navigation helper
  import { t } from 'svelte-i18n'; // For internationalization
  import LanguageSwitcher from './LanguageSwitcher.svelte'; // Language switcher component
  import { tick } from 'svelte'; // Svelte utility

  // Initialize Supabase client
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);

  /**
   * Navigation items configuration
   * @property {string} key - Translation key for the navigation item
   * @property {string} href - Route path for the navigation item
   * @property {boolean} requiresAuth - Whether the item requires authenticated access
   */
  const navItemKeys = [
    { key: 'nav.ourHoney', href: '/our-honey', requiresAuth: false },
    { key: 'nav.ourStory', href: '/our-story', requiresAuth: false },
    { key: 'nav.journal', href: '/journal', requiresAuth: false },
    { key: 'nav.contact', href: '/contact', requiresAuth: false },
   
  ];

  // Component state
  let mobileMenuOpen = false; // Controls mobile menu visibility
  let searchQuery = ''; // Stores search input value
  let userDisplayName = ''; // Stores formatted user name for display

  /**
   * Handles search form submission
   * Redirects to search page with query parameter
   */
  function handleSearch() {
    if (searchQuery.trim()) {
      goto(`/search?q=${searchQuery.trim()}`);
      searchQuery = '';
      mobileMenuOpen = false; // Close mobile menu on search
    }
  }

  /**
   * Handles user logout
   * @async
   * @throws {Error} If logout fails
   */
  async function handleLogout() {
    const { error } = await supabase.auth.signOut();
    if (error) {
      console.error('Error logging out:', error.message);
    } else {
      userStore.set({ session: null, user: null, profileLoading: false });
      goto('/');
    }
    mobileMenuOpen = false;
  }

  /**
   * Toggles mobile menu visibility
   */
  function toggleMobileMenu() {
    mobileMenuOpen = !mobileMenuOpen;
  }

  // Component lifecycle
  userStore.subscribe((value) => {
    /**
     * Subscribe to user store changes to update display name
     * Uses full_name if available, otherwise falls back to email username
     */
    if (value.user) {
      userDisplayName = value.user.full_name || value.user.email?.split('@')[0] || 'Account';
    } else {
      userDisplayName = '';
    }
  });
</script>

<nav class="bg-white sticky top-0 z-50 py-4">
  <div class="container mx-auto px-6">
    <div class="flex items-center justify-between">
      <a href="/" class="text-2xl sm:text-5xl font-bold text-black tracking-tight font-dancing">m'mmiere</a>
      
      <div class="hidden md:flex items-center space-x-8 mt-4 text-[12px]">
        {#each navItemKeys as item}
          {#if !item.requiresAuth || (item.requiresAuth && $userStore.user)}
            <a 
              href={item.href} 
              class="font-semibold text-gray-800 hover:text-black transition-colors"
            >
              {$t(item.key)}  
            </a>
          {/if}
        {/each}
      </div>

      <div class="hidden md:flex items-center space-x-6 mt-4 text-[12px]">

        {#if $userStore.user}
          <span class="font-semibold text-gray-800">{$t('nav.hi')}, {userDisplayName}</span>
          <button 
            on:click={handleLogout} 
            class="font-semibold text-gray-800 hover:text-black transition-colors"
          >
            {$t('nav.logout')}
          </button>
        {:else}
          <a href="/login" class="font-semibold text-gray-800 hover:text-black transition-colors">
            {$t('nav.login')}
          </a>
        {/if}
        
        <a href="/cart" class="font-semibold text-gray-800 hover:text-black transition-colors">
          {$t('nav.cart')} {#if $cart.length > 0}({$cart.length}){/if}
        </a>
        
        <form on:submit|preventDefault={handleSearch} class="relative flex items-center">
          <input
            bind:value={searchQuery}
            type="text"
            placeholder={$t('nav.search')}
            class="border border-gray-300 rounded-md py-1 pl-3 pr-8 text-sm font-bold focus:outline-none focus:ring-1 focus:ring-black w-32 hover:w-48 focus:w-48 transition-all duration-300"
          />
          <button type="submit" class="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 hover:text-black">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </button>
        </form>
      </div>
      
      <div class="md:hidden flex items-center space-x-4 text-[12px]">
        {#if $userStore.user}
          <button 
            on:click={handleLogout} 
            class="font-semibold text-gray-800 hover:text-black transition-colors"
          >
            {$t('nav.logout')}
          </button>
        {:else}
          <a href="/login" class="font-semibold text-gray-800 hover:text-black transition-colors">
            {$t('nav.login')}
          </a>
        {/if}
        
        <a href="/cart" class=" font-semibold text-gray-800 hover:text-black transition-colors">
          {$t('nav.cart')} {#if $cart.length > 0}({$cart.length}){/if}
        </a>
        
        <button on:click={() => mobileMenuOpen = !mobileMenuOpen} class="text-gray-500 hover:text-black">
          {#if mobileMenuOpen}
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          {:else}
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16" />
            </svg>
          {/if}
        </button>
      </div>
    </div>
  </div>

  {#if mobileMenuOpen}
    <div class="md:hidden border-t border-gray-200" class:hidden={!mobileMenuOpen}>
      <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
        {#each navItemKeys as item}
         {#if !item.requiresAuth || (item.requiresAuth && $userStore.user)}
            <a 
              href={item.href} 
              class="block px-3 py-2 rounded-md text-base font-semibold text-gray-800 hover:text-black hover:bg-gray-50 transition-colors"
              on:click={() => mobileMenuOpen = false}
            >
              {$t(item.key)}
            </a>
          {/if}
        {/each}
      </div>
      <div class="pt-4 pb-3 border-t border-gray-200">
        <div class="px-2 space-y-1">
          {#if $userStore.user}
            <div class="px-3 py-2">
              <p class="text-base font-semibold text-gray-800">{userDisplayName}</p>
              {#if $userStore.user.email && userDisplayName !== $userStore.user.email.split('@')[0]}
                <p class="text-sm font-semibold text-gray-500">{$userStore.user.email}</p>
              {/if}
            </div>
            <button 
              on:click={handleLogout} 
              class="block w-full text-left px-3 py-2 rounded-md text-base font-semibold text-gray-800 hover:text-black hover:bg-gray-50 transition-colors"
            >
              {$t('nav.logout')}
            </button>
          {:else}
            <a 
              href="/login" 
              class="block px-3 py-2 rounded-md text-base font-semibold text-gray-800 hover:text-black hover:bg-gray-50 transition-colors"
              on:click={() => mobileMenuOpen = false}
            >
              {$t('nav.login')}
            </a>
          {/if}
          <a 
            href="/cart" 
            class="block px-3 py-2 rounded-md text-base font-semibold text-gray-800 hover:text-black hover:bg-gray-50 transition-colors"
            on:click={() => mobileMenuOpen = false}
          >
            {$t('nav.cart')} {#if $cart.length > 0}({$cart.length}){/if}
          </a>
          <div class="px-3 py-2">
            <form on:submit|preventDefault={handleSearch}>
              <input 
                bind:value={searchQuery}
                type="text"
                placeholder={$t('nav.search')}
                class="w-full border border-gray-300 rounded-md py-2 px-3 text-sm focus:outline-none focus:ring-1 focus:ring-black"
              />
            </form>
          </div>
        </div>
      </div>
    </div>
  {/if}
</nav>
