<script setup>
import { RouterView } from 'vue-router'
import AppNav from './components/AppNav.vue'
</script>

<template>
  <div class="min-h-screen bg-slate-50 text-slate-900">
    <header
      class="flex flex-col items-center gap-6 border-b border-slate-200 bg-white px-6 py-6 sm:flex-row sm:justify-between"
    >
      <img
        alt="Vue logo"
        class="h-16 w-auto"
        src="@/assets/logo.svg"
        width="125"
        height="125"
      />
      <AppNav />
    </header>

    <main class="mx-auto max-w-5xl px-6">
      <RouterView />
    </main>
  </div>
</template>
