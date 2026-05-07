import { describe, it, expect, vi, beforeEach } from 'vitest'
import { AuthService, AuthError } from './authService'

function createHttpStub() {
  return { post: vi.fn(), get: vi.fn() }
}

function createTokenStorageStub() {
  return {
    getToken: vi.fn(),
    setToken: vi.fn(),
    clearToken: vi.fn(),
  }
}

describe('AuthService', () => {
  let http
  let tokenStorage
  let service

  beforeEach(() => {
    http = createHttpStub()
    tokenStorage = createTokenStorageStub()
    service = new AuthService({ http, tokenStorage })
  })

  describe('login', () => {
    it('posts to the correct path with email and password', async () => {
      http.post.mockResolvedValue({ data: { token: 'abc' } })
      await service.login('a@b.com', 'pw')
      expect(http.post).toHaveBeenCalledWith('/users/tokens/sign_in', {
        email: 'a@b.com',
        password: 'pw',
      })
    })

    it('persists the returned token on success', async () => {
      http.post.mockResolvedValue({ data: { token: 'abc.def' } })
      await service.login('a@b.com', 'pw')
      expect(tokenStorage.setToken).toHaveBeenCalledWith('abc.def')
    })

    it('returns the response payload on success', async () => {
      http.post.mockResolvedValue({ data: { token: 'abc', user: { id: 1 } } })
      const result = await service.login('a@b.com', 'pw')
      expect(result).toEqual({ token: 'abc', user: { id: 1 } })
    })

    it('clears any existing token and throws AuthError on failure', async () => {
      http.post.mockRejectedValue({
        response: { data: { error_message: 'Invalid credentials' } },
      })
      await expect(service.login('a@b.com', 'bad')).rejects.toBeInstanceOf(
        AuthError,
      )
      expect(tokenStorage.clearToken).toHaveBeenCalled()
    })

    it('uses the server error_message when available', async () => {
      http.post.mockRejectedValue({
        response: { data: { error_message: 'Invalid credentials' } },
      })
      await expect(service.login('a@b.com', 'bad')).rejects.toThrow(
        'Invalid credentials',
      )
    })

    it('falls back to a default message when none is provided', async () => {
      http.post.mockRejectedValue({})
      await expect(service.login('a@b.com', 'bad')).rejects.toThrow(
        'Login failed',
      )
    })
  })

  describe('logout', () => {
    it('clears the token', () => {
      service.logout()
      expect(tokenStorage.clearToken).toHaveBeenCalled()
    })
  })

  describe('checkAuth', () => {
    it('GETs the check path and returns the body', async () => {
      http.get.mockResolvedValue({ data: { ok: true } })
      const result = await service.checkAuth()
      expect(http.get).toHaveBeenCalledWith('/auth/check')
      expect(result).toEqual({ ok: true })
    })
  })

  describe('construction', () => {
    it('throws when http is missing', () => {
      expect(() => new AuthService({ tokenStorage })).toThrow(/http/)
    })

    it('throws when tokenStorage is missing', () => {
      expect(() => new AuthService({ http })).toThrow(/tokenStorage/)
    })
  })
})
