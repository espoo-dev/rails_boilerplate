import { API_BASE_URL } from '@/config/env'
import { createHttpClient } from './httpClient'
import { createTokenStorage } from './tokenStorage'
import { AuthService } from './authService'
import { UsersService } from './usersService'

export function createServiceContainer({
  baseURL = API_BASE_URL,
  storage,
} = {}) {
  const tokenStorage = createTokenStorage(storage)
  const http = createHttpClient({
    baseURL,
    tokenProvider: () => tokenStorage.getToken(),
  })

  return {
    http,
    tokenStorage,
    authService: new AuthService({ http, tokenStorage }),
    usersService: new UsersService({ http }),
  }
}
