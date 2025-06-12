<script lang="ts">
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);
  import { goto } from '$app/navigation';
  import { onMount } from 'svelte';

  let email = '';
  let loading = false;
  let message = '';
  let error = '';

  onMount(() => {
    // Redirect if already logged in
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session) {
        goto('/'); // Or to a dashboard page
      }
    });
  });

  async function handleLogin() {
    loading = true;
    message = '';
    error = '';
    try {
      const { error: authError } = await supabase.auth.signInWithOtp({
        email,
        options: {
          // emailRedirectTo: `${window.location.origin}/auth/callback` // Ensure this matches your Supabase config
          emailRedirectTo: `${window.location.origin}/` // Redirect to home after successful login from email link
        }
      });
      if (authError) {
        throw authError;
      }
      message = 'Check your email for the login link!';
    } catch (err: any) {
      error = err.error_description || err.message;
    } finally {
      loading = false;
    }
  }
</script>

<svelte:head>
  <title>Login - m'mmiere</title>
</svelte:head>

<div class="min-h-[calc(100vh-12rem)] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
  <div class="max-w-md w-full space-y-8 p-10 bg-white shadow-xl rounded-lg">
    <div>
      <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
        Sign in to m'mmiere
      </h2>
    </div>
    <form class="mt-8 space-y-6" on:submit|preventDefault={handleLogin}>
      <div class="rounded-md shadow-sm -space-y-px">
        <div>
          <label for="email-address" class="sr-only">Email address</label>
          <input 
            id="email-address" 
            name="email" 
            type="email" 
            autocomplete="email" 
            required 
            bind:value={email} 
            class="appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-black focus:border-black focus:z-10 sm:text-sm"
            placeholder="Email address"
            disabled={loading}
          />
        </div>
      </div>

      {#if message}
        <p class="text-sm text-green-600">{message}</p>
      {/if}
      {#if error}
        <p class="text-sm text-red-600">{error}</p>
      {/if}

      <div>
        <button 
          type="submit" 
          class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-black hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black transition-colors duration-150"
          disabled={loading}
        >
          {#if loading}
            <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            Processing...
          {:else}
            Send Magic Link
          {/if}
        </button>
      </div>
    </form>
  </div>
</div>
