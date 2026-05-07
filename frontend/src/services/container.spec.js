import { describe, it, expect } from 'vitest'
import { createServiceContainer } from './container'
import { AuthService } from './authService'
import { UsersService } from './usersService'

function createMemoryStorage() {
  const data = new Map()
  return {
    getItem: (k) => (data.has(k) ? data.get(k) : null),
    setItem: (k, v) => data.set(k, String(v)),
    removeItem: (k) => data.delete(k),
  }
}

describe('createServiceContainer', () => {
  it('wires up authService, usersService, http, and tokenStorage', () => {
    const container = createServiceContainer({ storage: createMemoryStorage() })
    expect(container.authService).toBeInstanceOf(AuthService)
    expect(container.usersService).toBeInstanceOf(UsersService)
    expect(container.http).toBeDefined()
    expect(container.tokenStorage).toBeDefined()
  })

  it('shares one http client between services', () => {
    const container = createServiceContainer({ storage: createMemoryStorage() })
    expect(container.authService.http).toBe(container.http)
    expect(container.usersService.http).toBe(container.http)
  })

  it('shares the tokenStorage with authService', () => {
    const container = createServiceContainer({ storage: createMemoryStorage() })
    expect(container.authService.tokenStorage).toBe(container.tokenStorage)
  })
})
