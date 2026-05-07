import { describe, it, expect, vi, beforeEach } from 'vitest'
import { createPinia } from 'pinia'
import { withSetup } from '@/test/withSetup'
import { SERVICES_KEY } from '@/services/keys'
import { AUTH_STATUS } from '@/stores/auth'
import { useAuth } from './useAuth'

function mountUseAuth({ authService }) {
  return withSetup(() => useAuth(), {
    plugins: [createPinia()],
    provides: { [SERVICES_KEY]: { authService } },
  })
}

describe('useAuth', () => {
  let authService

  beforeEach(() => {
    authService = {
      login: vi.fn(),
      logout: vi.fn(),
    }
  })

  it('exposes reactive state from the auth store', () => {
    const [result, app] = mountUseAuth({ authService })
    expect(result.isAuthenticated.value).toBe(false)
    expect(result.status.value).toBe(AUTH_STATUS.IDLE)
    app.unmount()
  })

  it('sets loading then success on a successful login', async () => {
    authService.login.mockResolvedValue({ token: 'abc', user: { id: 1 } })
    const [result, app] = mountUseAuth({ authService })

    await result.login('a@b.com', 'pw')

    expect(authService.login).toHaveBeenCalledWith('a@b.com', 'pw')
    expect(result.status.value).toBe(AUTH_STATUS.SUCCESS)
    expect(result.isAuthenticated.value).toBe(true)
    expect(result.user.value).toEqual({ id: 1 })
    expect(result.error.value).toBeNull()
    app.unmount()
  })

  it('sets error state and rethrows on failure', async () => {
    authService.login.mockRejectedValue(new Error('Invalid credentials'))
    const [result, app] = mountUseAuth({ authService })

    await expect(result.login('a@b.com', 'bad')).rejects.toThrow(
      'Invalid credentials',
    )

    expect(result.status.value).toBe(AUTH_STATUS.ERROR)
    expect(result.error.value).toBe('Invalid credentials')
    expect(result.isAuthenticated.value).toBe(false)
    app.unmount()
  })

  it('logout calls the service and resets the store', () => {
    const [result, app] = mountUseAuth({ authService })
    result.logout()
    expect(authService.logout).toHaveBeenCalled()
    expect(result.isAuthenticated.value).toBe(false)
    expect(result.status.value).toBe(AUTH_STATUS.IDLE)
    app.unmount()
  })
})
