import { register, init, getLocaleFromNavigator, locale as currentLocale } from 'svelte-i18n';
import { setContext, getContext } from 'svelte';
import { writable } from 'svelte/store';

const I18N_CONTEXT_KEY = 'i18n';

// Register locales
register('en', () => import('./locales/en.json'));
register('ro', () => import('./locales/ro.json'));

// Normalize locale to just the language code (e.g., 'en-US' -> 'en', 'ro-RO' -> 'ro')
function normalizeLocale(locale: string | null): string {
  if (!locale) return 'en';
  
  // Extract just the language part before any dash
  const normalizedLocale = locale.split('-')[0].toLowerCase();
  
  // Only return supported locales
  return ['en', 'ro'].includes(normalizedLocale) ? normalizedLocale : 'en';
}

// Get browser locale and normalize it
const browserLocale = getLocaleFromNavigator();
console.log('Browser detected locale:', browserLocale);

// Normalize the locale
const initialLocale = normalizeLocale(browserLocale);
console.log('Setting initial locale to:', initialLocale);

// Initialize svelte-i18n
init({
  fallbackLocale: 'en', // Fallback to English when keys are missing
  initialLocale: initialLocale,
});

// Function to change locale
export function setLocale(newLocale: string) {
  currentLocale.set(newLocale);
  // Optionally, save preference to localStorage or user profile
  if (typeof localStorage !== 'undefined') {
    localStorage.setItem('preferred_locale', newLocale);
  }
}

// Function to get the current locale, useful for components
export function getLocale() {
  return currentLocale;
}

// Setup i18n context for Svelte components
export function setupI18n() {
  const { subscribe, set, update } = writable(currentLocale);
  currentLocale.subscribe(val => set(val)); // Keep the writable store in sync

  setContext(I18N_CONTEXT_KEY, {
    locale: { subscribe },
    t: (id: string, options?: any) => {
      // This is a simplified t function. For full features like interpolation,
      // you'd typically use the $t store directly in Svelte components ($t('key'))
      // or a more robust context setup if needed outside Svelte's reactive scope.
      // For now, we'll rely on $t in components.
      let message = id; // Fallback to id if translation not found
      const unsubscribe = currentLocale.subscribe(l => {
        // Placeholder for a more complex translation lookup if needed here
        // For now, components should use $t
      });
      unsubscribe();
      return message;
    }
  });
}

export function useI18n() {
  return getContext(I18N_CONTEXT_KEY);
}
