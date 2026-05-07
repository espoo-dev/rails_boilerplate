import { describe, it, expect, beforeEach } from 'vitest'
import { createTokenStorage } from './tokenStorage'

function createMemoryStorage() {
  const data = new Map()
  return {
    getItem: (k) => (data.has(k) ? data.get(k) : null),
    setItem: (k, v) => data.set(k, String(v)),
    removeItem: (k) => data.delete(k),
  }
}

describe('tokenStorage', () => {
  let storage
  let tokenStorage

  beforeEach(() => {
    storage = createMemoryStorage()
    tokenStorage = createTokenStorage(storage)
  })

  it('returns null when no token has been set', () => {
    expect(tokenStorage.getToken()).toBeNull()
  })

  it('persists and retrieves a token', () => {
    tokenStorage.setToken('abc.def.ghi')
    expect(tokenStorage.getToken()).toBe('abc.def.ghi')
  })

  it('clears a previously set token', () => {
    tokenStorage.setToken('abc.def.ghi')
    tokenStorage.clearToken()
    expect(tokenStorage.getToken()).toBeNull()
  })
})
