<script setup>
import LoginForm from '@/components/LoginForm.vue'
import { useAuth } from '@/composables/useAuth'

const { login, isLoading, error, isAuthenticated } = useAuth()

async function onSubmit({ email, password }) {
  try {
    await login(email, password)
  } catch {
    // useAuth has already populated the reactive `error` ref for the form.
  }
}
</script>

<template>
  <section class="flex flex-col items-center gap-6 py-12">
    <h2 class="text-2xl font-semibold text-slate-800">Login</h2>

    <p
      v-if="isAuthenticated"
      class="text-emerald-700"
      data-testid="login-success"
    >
      You are signed in.
    </p>

    <LoginForm
      v-else
      :loading="isLoading"
      :error="error"
      @submit="onSubmit"
    />
  </section>
</template>
