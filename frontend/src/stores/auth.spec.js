import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuthStore, AUTH_STATUS } from './auth'

describe('auth store', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('starts in the idle state with no token or user', () => {
    const store = useAuthStore()
    expect(store.token).toBeNull()
    expect(store.user).toBeNull()
    expect(store.status).toBe(AUTH_STATUS.IDLE)
    expect(store.error).toBeNull()
    expect(store.isAuthenticated).toBe(false)
    expect(store.isLoading).toBe(false)
  })

  it('flips isAuthenticated when a token is set', () => {
    const store = useAuthStore()
    store.setToken('abc')
    expect(store.isAuthenticated).toBe(true)
  })

  it('flips isLoading when status is loading', () => {
    const store = useAuthStore()
    store.setStatus(AUTH_STATUS.LOADING)
    expect(store.isLoading).toBe(true)
  })

  it('reset returns to initial state', () => {
    const store = useAuthStore()
    store.setToken('abc')
    store.setUser({ id: 1 })
    store.setStatus(AUTH_STATUS.ERROR)
    store.setError('boom')
    store.reset()
    expect(store.token).toBeNull()
    expect(store.user).toBeNull()
    expect(store.status).toBe(AUTH_STATUS.IDLE)
    expect(store.error).toBeNull()
  })
})
