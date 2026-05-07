import { describe, it, expect, vi, beforeEach } from 'vitest'

const createMock = vi.fn()

vi.mock('axios', () => ({
  default: { create: (...args) => createMock(...args) },
}))

import { createHttpClient } from './httpClient'

function captureInterceptor() {
  const interceptors = { request: { use: vi.fn() } }
  const instance = { interceptors }
  createMock.mockReturnValue(instance)
  return { instance, interceptors }
}

describe('createHttpClient', () => {
  beforeEach(() => {
    createMock.mockReset()
  })

  it('forwards baseURL to axios.create', () => {
    captureInterceptor()
    createHttpClient({ baseURL: 'http://api.test', tokenProvider: () => null })
    expect(createMock).toHaveBeenCalledWith({ baseURL: 'http://api.test' })
  })

  it('adds the Authorization header when tokenProvider returns a token', () => {
    const { interceptors } = captureInterceptor()
    createHttpClient({
      baseURL: 'http://api.test',
      tokenProvider: () => 'abc.def',
    })

    const requestInterceptor = interceptors.request.use.mock.calls[0][0]
    const result = requestInterceptor({ headers: {} })
    expect(result.headers.Authorization).toBe('Bearer abc.def')
  })

  it('omits the Authorization header when tokenProvider returns null', () => {
    const { interceptors } = captureInterceptor()
    createHttpClient({
      baseURL: 'http://api.test',
      tokenProvider: () => null,
    })

    const requestInterceptor = interceptors.request.use.mock.calls[0][0]
    const result = requestInterceptor({ headers: {} })
    expect(result.headers.Authorization).toBeUndefined()
  })

  it('tolerates a missing tokenProvider', () => {
    const { interceptors } = captureInterceptor()
    createHttpClient({ baseURL: 'http://api.test' })

    const requestInterceptor = interceptors.request.use.mock.calls[0][0]
    const result = requestInterceptor({ headers: {} })
    expect(result.headers.Authorization).toBeUndefined()
  })
})
