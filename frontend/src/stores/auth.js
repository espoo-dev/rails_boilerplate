import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

export const AUTH_STATUS = Object.freeze({
  IDLE: 'idle',
  LOADING: 'loading',
  SUCCESS: 'success',
  ERROR: 'error',
})

export const useAuthStore = defineStore('auth', () => {
  const token = ref(null)
  const user = ref(null)
  const status = ref(AUTH_STATUS.IDLE)
  const error = ref(null)

  const isAuthenticated = computed(() => Boolean(token.value))
  const isLoading = computed(() => status.value === AUTH_STATUS.LOADING)

  function setToken(value) {
    token.value = value
  }

  function setUser(value) {
    user.value = value
  }

  function setStatus(value) {
    status.value = value
  }

  function setError(value) {
    error.value = value
  }

  function reset() {
    token.value = null
    user.value = null
    status.value = AUTH_STATUS.IDLE
    error.value = null
  }

  return {
    token,
    user,
    status,
    error,
    isAuthenticated,
    isLoading,
    setToken,
    setUser,
    setStatus,
    setError,
    reset,
  }
})
