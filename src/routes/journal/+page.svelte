<script lang="ts">
  import { t } from 'svelte-i18n';

  // In the future, this data would come from Supabase
  const posts = [
    {
      id: 1,
      title: 'The Magic of Acacia Honey',
      title_ro: 'Magia Mierii de Salcâm',
      excerpt: 'Discover the delicate flavors and incredible health benefits of one of the world\'s most sought-after honey varieties.',
      excerpt_ro: 'Descoperiți aromele delicate și beneficiile incredibile pentru sănătate ale unuia dintre cele mai căutate soiuri de miere din lume.',
      date: '2023-10-26',
      author: 'Ana Popescu',
      imageUrl: 'https://images.unsplash.com/photo-1516223395-883528346231?q=80&w=2070&auto=format&fit=crop',
      slug: 'the-magic-of-acacia-honey'
    },
    {
      id: 2,
      title: 'A Beekeeper\'s Year: A Season of Hard Work',
      title_ro: 'Anul unui Apicultor: Un Sezon de Muncă Grea',
      excerpt: 'A behind-the-scenes look at the challenges and rewards of beekeeping throughout the changing seasons.',
      excerpt_ro: 'O privire în culise la provocările și recompensele apiculturii de-a lungul anotimpurilor în schimbare.',
      date: '2023-09-15',
      author: 'Mihai Ionescu',
      imageUrl: 'https://images.unsplash.com/photo-1550948463-3a4369e5b77c?q=80&w=1974&auto=format&fit=crop',
      slug: 'a-beekeepers-year'
    },
    {
      id: 3,
      title: 'Why Raw Honey is Better for You',
      title_ro: 'De ce este Mierea Crudă mai Bună pentru Tine',
      excerpt: 'We break down the science behind why raw, unfiltered honey retains more nutrients and beneficial properties.',
      excerpt_ro: 'Analizăm știința din spatele motivului pentru care mierea crudă, nefiltrată, păstrează mai mulți nutrienți și proprietăți benefice.',
      date: '2023-08-02',
      author: 'Ana Popescu',
      imageUrl: 'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?q=80&w=1974&auto=format&fit=crop',
      slug: 'why-raw-honey-is-better'
    }
  ];

  const locale = $t('locale');
</script>

<svelte:head>
  <title>{$t('journal.title')} - m'mmiere</title>
  <meta name="description" content={$t('journal.metaDescription')} />
</svelte:head>

<div class="bg-white py-16 sm:py-24">
  <div class="mx-auto max-w-7xl px-6 lg:px-8">
    <div class="mx-auto max-w-2xl text-center">
      <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl">{$t('journal.header')}</h1>
      <p class="mt-4 text-lg leading-8 text-gray-600">{$t('journal.subHeader')}</p>
    </div>
    <div class="mx-auto mt-16 grid max-w-2xl grid-cols-1 gap-x-8 gap-y-20 lg:mx-0 lg:max-w-none lg:grid-cols-3">
      {#each posts as post}
        <article class="flex flex-col items-start justify-between">
          <div class="relative w-full">
            <img src={post.imageUrl} alt="" class="aspect-[16/9] w-full rounded-2xl bg-gray-100 object-cover sm:aspect-[2/1] lg:aspect-[3/2]">
            <div class="absolute inset-0 rounded-2xl ring-1 ring-inset ring-gray-900/10"></div>
          </div>
          <div class="max-w-xl">
            <div class="mt-8 flex items-center gap-x-4 text-xs">
              <time datetime={post.date} class="text-gray-500">{new Date(post.date).toLocaleDateString($t('locale'), { year: 'numeric', month: 'long', day: 'numeric' })}</time>
              <!-- <a href={`/journal/category/placeholder`} class="relative z-10 rounded-full bg-gray-50 px-3 py-1.5 font-medium text-gray-600 hover:bg-gray-100">Category</a> -->
            </div>
            <div class="group relative">
              <h3 class="mt-3 text-lg font-semibold leading-6 text-gray-900 group-hover:text-gray-600">
                <a href={`/journal/${post.slug}`}>
                  <span class="absolute inset-0"></span>
                  {locale === 'ro' ? post.title_ro : post.title}
                </a>
              </h3>
              <p class="mt-5 line-clamp-3 text-sm leading-6 text-gray-600">{locale === 'ro' ? post.excerpt_ro : post.excerpt}</p>
            </div>
            <div class="relative mt-8 flex items-center gap-x-4">
              <div class="relative h-10 w-10">
                <svg class="h-full w-full text-gray-300" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8.999a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
                <span class="absolute -inset-1.5"></span>
                <span class="sr-only">{post.author}</span>
              </div>
              <div class="text-sm leading-6">
                <p class="font-semibold text-gray-900">
                  <a href={`/journal/author/placeholder`}>
                    <span class="absolute inset-0"></span>
                    {post.author}
                  </a>
                </p>
                <p class="text-gray-600">{$t('journal.authorRole')}</p>
              </div>
            </div>
          </div>
        </article>
      {/each}
    </div>
  </div>
</div>
