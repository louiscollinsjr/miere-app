<script lang="ts">
  import { t } from 'svelte-i18n';
</script>

<svelte:head>
  <title>{$t('legal.privacy.title')} - m'mmiere</title>
</svelte:head>

<div class="bg-white py-16 sm:py-24">
  <div class="mx-auto max-w-3xl px-6 lg:px-8">
    <div class="mx-auto max-w-2xl text-center">
      <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl">{$t('legal.privacy.title')}</h1>
      <p class="mt-4 text-lg leading-8 text-gray-600">{$t('legal.lastUpdated', { values: { date: 'October 27, 2023' } })}</p>
    </div>
    <div class="mt-16 prose prose-lg lg:prose-xl mx-auto text-gray-700">
      <h2>1. Introduction</h2>
      <p>Welcome to m'mmiere. We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about our policy, or our practices with regards to your personal information, please contact us.</p>
  
      <h2>2. Information We Collect</h2>
      <p>We collect personal information that you voluntarily provide to us when you register on the website, express an interest in obtaining information about us or our products and services, when you participate in activities on the website or otherwise when you contact us.</p>
      <p>The personal information that we collect depends on the context of your interactions with us and the website, the choices you make and the products and features you use. The personal information we collect may include the following: Name and Contact Data, Credentials, and Payment Data.</p>
  
      <h2>3. How We Use Your Information</h2>
      <p>We use personal information collected via our website for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations.</p>
  
      <h2>4. Will Your Information Be Shared With Anyone?</h2>
      <p>We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations.</p>
  
      <h2>5. How Long Do We Keep Your Information?</h2>
      <p>We keep your information for as long as necessary to fulfill the purposes outlined in this privacy policy unless otherwise required by law.</p>
  
      <h2>6. How Do We Keep Your Information Safe?</h2>
      <p>We aim to protect your personal information through a system of organizational and technical security measures.</p>
  
      <h2>7. Do We Collect Information From Minors?</h2>
      <p>We do not knowingly solicit data from or market to children under 18 years of age.</p>
  
      <h2>8. What Are Your Privacy Rights?</h2>
      <p>In some regions (like the European Economic Area), you have rights that allow you greater access to and control over your personal information. You may review, change, or terminate your account at any time.</p>
  
      <h2>9. Controls for Do-Not-Track Features</h2>
      <p>Most web browsers and some mobile operating systems and mobile applications include a Do-Not-Track (“DNT”) feature or setting you can activate to signal your privacy preference not to have data about your online browsing activities monitored and collected. At this stage no uniform technology standard for recognizing and implementing DNT signals has been finalized. As such, we do not currently respond to DNT browser signals or any other mechanism that automatically communicates your choice not to be tracked online.</p>
  
      <h2>10. How Can You Contact Us About This Policy?</h2>
      <p>If you have questions or comments about this policy, you may contact us using the form on our contact page.</p>
    </div>
  </div>
</div>
