<script lang="ts">
  // Import fonts first to ensure they load before other styles
  import '@fontsource/inter/400.css';
  import '@fontsource/inter/500.css';
  import '@fontsource/inter/600.css';
  import '@fontsource/quicksand/400.css';
  import '@fontsource/quicksand/500.css';
  import '@fontsource/quicksand/700.css';
  import '@fontsource/dancing-script/400.css';
  import '@fontsource/dancing-script/700.css';
  import '../app.css';
  import { t } from 'svelte-i18n';
  import Navigation from '$lib/components/Navigation.svelte';
  import Footer from '$lib/components/Footer.svelte';
  import { onMount } from 'svelte';
  import { userStore, type UserProfile } from '$lib/stores/user';
  import { createClient } from '@supabase/supabase-js';
  import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
  const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);
  import { setupI18n, setLocale } from '$lib/i18n';
  import { Toaster } from 'svelte-sonner';

  let { children } = $props();

  setupI18n(); // Initialize i18n context

  onMount(() => {
    // Attempt to load preferred locale from localStorage
    const preferredLocale = localStorage.getItem('preferred_locale');
    if (preferredLocale) {
      setLocale(preferredLocale);
    }

    const { data: authListener } = supabase.auth.onAuthStateChange(async (event, session) => {
      const currentUser = session?.user ?? null;
      let userProfileData: UserProfile | null = null;

      if (currentUser) {
        userStore.update(store => ({ ...store, profileLoading: true }));
        try {
          const { data: profile, error } = await supabase
            .from('profiles')
            .select('full_name, preferred_language') // Only select needed fields
            .eq('id', currentUser.id)
            .single();

          if (error && error.code !== 'PGRST116') {
            console.error('Error fetching profile:', error);
          } else if (profile) {
            userProfileData = { ...currentUser, ...profile };
            // If user has a preferred language in their profile, set it
            if (profile.preferred_language) {
              setLocale(profile.preferred_language);
            }
          }
        } catch (e) {
          console.error('Exception fetching profile:', e);
        }
      }
      
      userStore.set({
        session,
        user: userProfileData || currentUser, 
        profileLoading: false,
      });
    });

    // Initial session check
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session) {
        supabase.auth.setSession(session); // This will trigger onAuthStateChange
      } else {
        userStore.set({ session: null, user: null, profileLoading: false });
      }
    });

    return () => {
      authListener?.unsubscribe();
    };
  });
</script>

<svelte:head>
  <title>m'mmiere - {$t('seo.title')}</title>
  <meta name="description" content={$t('seo.description')} />
</svelte:head>

<div class="min-h-screen flex flex-col bg-white text-black font-sans">
  <Navigation />
  
  <main class="flex-grow container mx-auto px-4 py-8">
    {@render children()}
  </main>
  <Footer />
</div>
