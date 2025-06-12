<script lang="ts">
  import { t } from 'svelte-i18n';
</script>

<svelte:head>
  <title>{$t('legal.terms.title')} - m'mmiere</title>
</svelte:head>

<div class="bg-white py-16 sm:py-24">
  <div class="mx-auto max-w-3xl px-6 lg:px-8">
    <div class="mx-auto max-w-2xl text-center">
      <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl">{$t('legal.terms.title')}</h1>
      <p class="mt-4 text-lg leading-8 text-gray-600">{$t('legal.lastUpdated', { values: { date: 'October 27, 2023' } })}</p>
    </div>
    <div class="mt-16 prose prose-lg lg:prose-xl mx-auto text-gray-700">
      <h2>1. Agreement to Terms</h2>
      <p>By using our services, you agree to be bound by these Terms. If you don’t agree to be bound by these Terms, do not use the services.</p>
  
      <h2>2. Privacy Policy</h2>
      <p>Please refer to our Privacy Policy for information on how we collect, use and disclose information from our users.</p>
  
      <h2>3. Changes to Terms or Services</h2>
      <p>We may update the Terms at any time, in our sole discretion. If we do so, we’ll let you know either by posting the updated Terms on the Site or through other communications. It’s important that you review the Terms whenever we update them or you use the Services.</p>
  
      <h2>4. Who May Use the Services</h2>
      <p>You may use the Services only if you are 18 years or older and capable of forming a binding contract with m'mmiere and are not barred from using the Services under applicable law.</p>
  
      <h2>5. Purchases</h2>
      <p>If you wish to purchase any product or service made available through the Service ("Purchase"), you may be asked to supply certain information relevant to your Purchase including, without limitation, your credit card number, the expiration date of your credit card, your billing address, and your shipping information.</p>
  
      <h2>6. Content Ownership</h2>
      <p>We do not claim any ownership rights in any User Content and nothing in these Terms will be deemed to restrict any rights that you may have to use and exploit your User Content.</p>
  
      <h2>7. General Prohibitions</h2>
      <p>You agree not to do any of the following: Post, upload, publish, submit or transmit any Content that: (i) infringes, misappropriates or violates a third party’s patent, copyright, trademark, trade secret, moral rights or other intellectual property rights, or rights of publicity or privacy; (ii) violates, or encourages any conduct that would violate, any applicable law or regulation or would give rise to civil liability.</p>
  
      <h2>8. Termination</h2>
      <p>We may terminate your access to and use of the Services, at our sole discretion, at any time and without notice to you.</p>
  
      <h2>9. Disclaimers</h2>
      <p>The Services and Content are provided “AS IS,” without warranty of any kind. Without limiting the foregoing, we explicitly disclaim any warranties of merchantability, fitness for a particular purpose, quiet enjoyment or non-infringement.</p>
  
      <h2>10. Contact Information</h2>
      <p>If you have any questions about these Terms, please contact us.</p>
    </div>
  </div>
</div>
