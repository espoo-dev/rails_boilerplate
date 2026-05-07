<script setup>
import { ref } from 'vue'

defineProps({
  loading: { type: Boolean, default: false },
  error: { type: String, default: null },
})

const emit = defineEmits(['submit'])

const email = ref('admin@email.com')
const password = ref('password')

function onSubmit() {
  emit('submit', { email: email.value, password: password.value })
}
</script>

<template>
  <form
    class="flex flex-col gap-4 w-full max-w-sm"
    data-testid="login-form"
    @submit.prevent="onSubmit"
  >
    <div class="flex flex-col gap-1">
      <label for="email" class="text-sm font-medium text-slate-700">
        Email
      </label>
      <input
        id="email"
        v-model="email"
        type="email"
        required
        autocomplete="username"
        class="rounded border border-slate-300 px-3 py-2 focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
      />
    </div>

    <div class="flex flex-col gap-1">
      <label for="password" class="text-sm font-medium text-slate-700">
        Password
      </label>
      <input
        id="password"
        v-model="password"
        type="password"
        required
        autocomplete="current-password"
        class="rounded border border-slate-300 px-3 py-2 focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
      />
    </div>

    <p
      v-if="error"
      class="text-sm text-red-600"
      role="alert"
      data-testid="login-error"
    >
      {{ error }}
    </p>

    <button
      type="submit"
      :disabled="loading"
      class="rounded bg-emerald-600 px-4 py-2 font-medium text-white hover:bg-emerald-700 disabled:opacity-60 disabled:cursor-not-allowed"
    >
      {{ loading ? 'Signing in…' : 'Login' }}
    </button>
  </form>
</template>
