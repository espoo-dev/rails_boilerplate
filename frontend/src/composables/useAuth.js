import { storeToRefs } from 'pinia'
import { useAuthStore, AUTH_STATUS } from '@/stores/auth'
import { useServices } from './useServices'

export function useAuth() {
  const store = useAuthStore()
  const { authService } = useServices()
  const { token, user, status, error, isAuthenticated, isLoading } =
    storeToRefs(store)

  async function login(email, password) {
    store.setStatus(AUTH_STATUS.LOADING)
    store.setError(null)
    try {
      const data = await authService.login(email, password)
      store.setToken(data.token)
      if (data.user) store.setUser(data.user)
      store.setStatus(AUTH_STATUS.SUCCESS)
      return data
    } catch (err) {
      store.setError(err.message)
      store.setStatus(AUTH_STATUS.ERROR)
      store.setToken(null)
      throw err
    }
  }

  function logout() {
    authService.logout()
    store.reset()
  }

  return {
    token,
    user,
    status,
    error,
    isAuthenticated,
    isLoading,
    login,
    logout,
  }
}
