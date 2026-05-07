import { describe, it, expect, vi, beforeEach } from 'vitest'
import { UsersService } from './usersService'

describe('UsersService', () => {
  let http
  let service

  beforeEach(() => {
    http = { get: vi.fn() }
    service = new UsersService({ http })
  })

  it('GETs the users index path', async () => {
    http.get.mockResolvedValue({ data: [] })
    await service.list()
    expect(http.get).toHaveBeenCalledWith('/api/v1/users')
  })

  it('returns the response payload', async () => {
    const payload = [{ id: 1 }, { id: 2 }]
    http.get.mockResolvedValue({ data: payload })
    await expect(service.list()).resolves.toEqual(payload)
  })

  it('throws when http is missing', () => {
    expect(() => new UsersService({})).toThrow(/http/)
  })
})
