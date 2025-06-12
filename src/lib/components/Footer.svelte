<script lang="ts">
  import { t } from 'svelte-i18n';

  const currentYear = new Date().getFullYear();

  // Simplified main navigation links
  const mainLinks = [
    { name: $t('nav.ourHoney'), href: '/products' },
    { name: $t('nav.ourStory'), href: '/our-story' },
    { name: $t('nav.journal'), href: '/journal' },
    { name: $t('nav.contact'), href: '/contact' },
    { name: $t('footer.privacy'), href: '/privacy-policy' },
    { name: $t('footer.terms'), href: '/terms-of-service' },
  ];

  // Social media links
  const socialLinks = [
    { name: 'Instagram', href: 'https://instagram.com', icon: 'instagram' },
    { name: 'Bluesky', href: 'https://bluesky.com', icon: 'bluesky' },
    { name: 'Twitter', href: 'https://twitter.com', icon: 'twitter' },
    { name: 'Threads', href: 'https://threads.net', icon: 'threads' },
  ];
</script>

<footer class="bg-[#f5f5f7] font-inter">
  <div class="container max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
    <!-- Logo and tagline -->
    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8">
      <div>
        <a href="/" class="text-2xl sm:text-3xl font-bold text-black tracking-tight font-dancing">m'mmiere</a>
        <p class="mt-1 text-xs text-gray-500 max-w-xs">{$t('footer.tagline')}</p>
      </div>
      
      <!-- Social Icons -->
      <div class="flex space-x-6 mt-4 sm:mt-0">
        {#each socialLinks as social}
          <a href={social.href} class="text-gray-500 hover:text-gray-700 transition-colors" aria-label={social.name}>
            {#if social.icon === 'instagram'}
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#000000" viewBox="0 0 256 256"><path d="M128,80a48,48,0,1,0,48,48A48.05,48.05,0,0,0,128,80Zm0,80a32,32,0,1,1,32-32A32,32,0,0,1,128,160ZM176,24H80A56.06,56.06,0,0,0,24,80v96a56.06,56.06,0,0,0,56,56h96a56.06,56.06,0,0,0,56-56V80A56.06,56.06,0,0,0,176,24Zm40,152a40,40,0,0,1-40,40H80a40,40,0,0,1-40-40V80A40,40,0,0,1,80,40h96a40,40,0,0,1,40,40ZM192,76a12,12,0,1,1-12-12A12,12,0,0,1,192,76Z"></path></svg>
            {:else if social.icon === 'bluesky'}
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#000000" viewBox="0 0 256 256"><path d="M232.7,50.48C229,45.7,221.84,40,209,40c-16.85,0-38.46,11.28-57.81,30.16A140.07,140.07,0,0,0,136,87.53V56a8,8,0,0,0-16,0V87.53a140.07,140.07,0,0,0-15.15-17.37C85.49,51.28,63.88,40,47,40,34.16,40,27,45.7,23.3,50.48c-6.82,8.77-12.18,24.08-.21,71.2,6.05,23.83,19.51,33,30.63,36.42A44,44,0,0,0,128,205.27a44,44,0,0,0,74.28-47.17c11.12-3.4,24.57-12.59,30.63-36.42C239.63,95.24,244.85,66.1,232.7,50.48ZM92,208A28.12,28.12,0,0,1,88.86,152a8,8,0,1,0-1.76-15.9A43.64,43.64,0,0,0,66.36,144c-8.43.09-22-3.57-27.76-26.26C35.72,106.39,27,71.86,35.94,60.3,37.37,58.46,40.09,56,47,56c27.27,0,73,44.88,73,71.67V180A28,28,0,0,1,92,208ZM217.4,117.74c-5.77,22.69-19.33,26.34-27.77,26.26a43.6,43.6,0,0,0-20.74-7.95,8,8,0,1,0-1.76,15.9A28.11,28.11,0,1,1,136,180V127.67C136,100.88,181.69,56,209,56c6.95,0,9.66,2.46,11.1,4.3C229.05,71.86,220.28,106.39,217.4,117.74Z"></path></svg>
            {:else if social.icon === 'threads'}
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#000000" viewBox="0 0 256 256"><path d="M186.42,123.65a63.81,63.81,0,0,0-11.13-6.72c-4-29.89-24-39.31-33.1-42.07-19.78-6-42.51,1.19-52.85,16.7a8,8,0,0,0,13.32,8.88c6.37-9.56,22-14.16,34.89-10.27,9.95,3,16.82,10.3,20.15,21a81.05,81.05,0,0,0-15.29-1.43c-13.92,0-26.95,3.59-36.67,10.1C94.3,127.57,88,139,88,152c0,20.58,15.86,35.52,37.71,35.52a48,48,0,0,0,34.35-14.81c6.44-6.7,14-18.36,15.61-37.1.38.26.74.53,1.1.8C186.88,144.05,192,154.68,192,168c0,19.36-20.34,48-64,48-26.73,0-45.48-8.65-57.34-26.44C60.93,175,56,154.26,56,128s4.93-47,14.66-61.56C82.52,48.65,101.27,40,128,40c32.93,0,54,13.25,64.53,40.52a8,8,0,1,0,14.93-5.75C194.68,41.56,167.2,24,128,24,96,24,72.19,35.29,57.34,57.56,45.83,74.83,40,98.52,40,128s5.83,53.17,17.34,70.44C72.19,220.71,96,232,128,232c30.07,0,48.9-11.48,59.4-21.1C200.3,199.08,208,183,208,168,208,149.66,200.54,134.32,186.42,123.65Zm-37.89,38a31.94,31.94,0,0,1-22.82,9.9c-10.81,0-21.71-6-21.71-19.52,0-12.63,12-26.21,38.41-26.21A63.88,63.88,0,0,1,160,128.24C160,142.32,156,153.86,148.53,161.62Z"></path></svg>
            {:else if social.icon === 'twitter'}
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#000000" viewBox="0 0 256 256"><path d="M214.75,211.71l-62.6-98.38,61.77-67.95a8,8,0,0,0-11.84-10.76L143.24,99.34,102.75,35.71A8,8,0,0,0,96,32H48a8,8,0,0,0-6.75,12.3l62.6,98.37-61.77,68a8,8,0,1,0,11.84,10.76l58.84-64.72,40.49,63.63A8,8,0,0,0,160,224h48a8,8,0,0,0,6.75-12.29ZM164.39,208,62.57,48h29L193.43,208Z"></path></svg>
            {/if}
          </a>
        {/each}
      </div>
    </div>

    <!-- Simplified navigation -->
    <!-- <div class=" pt-6 pb-4">
      <nav>
        <ul class="flex flex-wrap justify-center sm:justify-start gap-x-6 gap-y-2">
          {#each mainLinks as link}
            <li>
              <a href={link.href} class="text-xs font-medium text-gray-700 hover:text-gray-900 hover:underline underline-offset-4 transition-all duration-200">
                {link.name}
              </a>
            </li>
          {/each}
        </ul>
      </nav>
    </div> -->

    <!-- Email and store locations -->
    <div class="pt-0">
      <p class="text-xs text-gray-600 text-center sm:text-left font-inter">
        More ways to shop: 
        <a href="/locations" class="text-blue-600 hover:underline underline-offset-4 transition-all duration-200">
          Find a honey pick up location
        </a> 
        near you. Or email us at 
        <a href="mailto:hello@mmmiere.com" class="text-blue-600 hover:underline underline-offset-4 transition-all duration-200">
          hello@mmmiere.com
        </a>
      </p>
    </div>

    <!-- Copyright info -->
    <div class="mt-4 border-t border-gray-200 pt-4 text-xs text-gray-600 text-center sm:text-left font-inter">
      <p>Copyright &copy; {currentYear} m'mmiere. {$t('common.allRightsReserved')} | Designed by atem ❤️ by the world.</p>
    </div>
  </div>
</footer>
