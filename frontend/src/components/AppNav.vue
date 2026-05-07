<script setup>
import { RouterLink } from 'vue-router'
</script>

<template>
  <nav class="flex gap-4 text-sm">
    <RouterLink
      to="/"
      class="px-3 py-1 rounded text-slate-700 hover:bg-emerald-100"
      active-class="text-emerald-700 font-medium"
    >
      Home
    </RouterLink>
    <RouterLink
      to="/about"
      class="px-3 py-1 rounded text-slate-700 hover:bg-emerald-100"
      active-class="text-emerald-700 font-medium"
    >
      About
    </RouterLink>
  </nav>
</template>
