<script lang="ts">
  import { t } from 'svelte-i18n';
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);
  import { userStore } from '$lib/stores/user';

  let formData = {
    name: '',
    email: '',
    message: ''
  };
  let formStatus: 'idle' | 'submitting' | 'success' | 'error' = 'idle';
  let statusMessage = '';

  // Pre-fill form if user is logged in
  userStore.subscribe(value => {
    if (value.user) {
      formData.name = value.user.full_name || '';
      formData.email = value.user.email || '';
    }
  });

  async function handleSubmit() {
    formStatus = 'submitting';
    statusMessage = '';

    // Basic validation
    if (!formData.name || !formData.email || !formData.message) {
      formStatus = 'error';
      statusMessage = $t('contact.form.error.allFields');
      return;
    }

    // In a real app, you would send this to a serverless function
    // that uses a secure mailer service. For this example, we'll
    // simulate a successful submission.
    console.log('Simulating form submission:', formData);
    await new Promise(resolve => setTimeout(resolve, 1000)); // Simulate network delay

    formStatus = 'success';
    statusMessage = $t('contact.form.success');
    formData = { name: '', email: '', message: '' };
  }
</script>

<svelte:head>
  <title>{$t('contact.title')} - m'mmiere</title>
  <meta name="description" content={$t('contact.metaDescription')} />
</svelte:head>

<div class="relative bg-white">
  <div class="absolute inset-0">
    <div class="absolute inset-y-0 left-0 w-1/2 bg-gray-50"></div>
  </div>
  <div class="relative mx-auto max-w-7xl lg:grid lg:grid-cols-5">
    <div class="bg-gray-50 py-16 px-4 sm:px-6 lg:col-span-2 lg:px-8 lg:py-24 xl:pr-12">
      <div class="mx-auto max-w-lg">
        <h2 class="text-2xl font-extrabold tracking-tight text-gray-900 sm:text-3xl">{$t('contact.infoTitle')}</h2>
        <p class="mt-3 text-lg leading-6 text-gray-500">{$t('contact.subHeader')}</p>
        <dl class="mt-8 text-base text-gray-500">
          <div>
            <dt class="sr-only">{$t('contact.infoAddress')}</dt>
            <dd>
              <p>{$t('contact.addressValue.line1')}</p>
              <p>{$t('contact.addressValue.line2')}</p>
            </dd>
          </div>
          <div class="mt-6">
            <dt class="sr-only">{$t('contact.infoPhone')}</dt>
            <dd class="flex">
              <svg class="h-6 w-6 flex-shrink-0 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 002.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 01-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 00-1.091-.852H4.5A2.25 2.25 0 002.25 6.75z" />
              </svg>
              <span class="ml-3">{$t('contact.phoneValue')}</span>
            </dd>
          </div>
          <div class="mt-3">
            <dt class="sr-only">{$t('contact.infoEmail')}</dt>
            <dd class="flex">
              <svg class="h-6 w-6 flex-shrink-0 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 01-2.25 2.25h-15a2.25 2.25 0 01-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25m19.5 0v.243a2.25 2.25 0 01-1.07 1.916l-7.5 4.615a2.25 2.25 0 01-2.36 0L3.32 8.91a2.25 2.25 0 01-1.07-1.916V6.75" />
              </svg>
              <span class="ml-3">{$t('contact.emailValue')}</span>
            </dd>
          </div>
        </dl>
      </div>
    </div>
    <div class="bg-white py-16 px-4 sm:px-6 lg:col-span-3 lg:py-24 lg:px-8 xl:pl-12">
      <div class="mx-auto max-w-lg lg:max-w-none">
        <form on:submit|preventDefault={handleSubmit} class="grid grid-cols-1 gap-y-6">
          <div>
            <label for="name" class="sr-only">{$t('contact.form.name')}</label>
            <input type="text" id="name" bind:value={formData.name} autocomplete="name" class="block w-full rounded-md border-gray-300 py-3 px-4 placeholder-gray-500 shadow-sm focus:border-black focus:ring-black" placeholder={$t('contact.form.name')}>
          </div>
          <div>
            <label for="email" class="sr-only">{$t('contact.form.email')}</label>
            <input type="email" id="email" bind:value={formData.email} autocomplete="email" class="block w-full rounded-md border-gray-300 py-3 px-4 placeholder-gray-500 shadow-sm focus:border-black focus:ring-black" placeholder={$t('contact.form.email')}>
          </div>
          <div>
            <label for="message" class="sr-only">{$t('contact.form.message')}</label>
            <textarea id="message" bind:value={formData.message} rows="4" class="block w-full rounded-md border-gray-300 py-3 px-4 placeholder-gray-500 shadow-sm focus:border-black focus:ring-black" placeholder={$t('contact.form.message')}></textarea>
          </div>
          <div>
            <button type="submit" disabled={formStatus === 'submitting'} class="inline-flex justify-center rounded-md border border-transparent bg-black py-3 px-6 text-base font-medium text-white shadow-sm hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-black focus:ring-offset-2 disabled:bg-gray-400">
              {#if formStatus === 'submitting'}
                {$t('contact.form.submitting')}
              {:else}
                {$t('contact.form.submit')}
              {/if}
            </button>
          </div>
        </form>
        {#if formStatus === 'success' || formStatus === 'error'}
          <div class="mt-4 text-center p-3 rounded-md" class:bg-green-100={formStatus === 'success'} class:text-green-800={formStatus === 'success'} class:bg-red-100={formStatus === 'error'} class:text-red-800={formStatus === 'error'}>
            {statusMessage}
          </div>
        {/if}
      </div>
    </div>
  </div>
</div>
