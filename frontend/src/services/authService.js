export class AuthError extends Error {
  constructor(message, { cause } = {}) {
    super(message)
    this.name = 'AuthError'
    if (cause) this.cause = cause
  }
}

const LOGIN_PATH = '/users/tokens/sign_in'
const CHECK_PATH = '/auth/check'

export class AuthService {
  constructor({ http, tokenStorage }) {
    if (!http) throw new Error('AuthService requires an http client')
    if (!tokenStorage) throw new Error('AuthService requires a tokenStorage')
    this.http = http
    this.tokenStorage = tokenStorage
  }

  async login(email, password) {
    try {
      const { data } = await this.http.post(LOGIN_PATH, { email, password })
      this.tokenStorage.setToken(data.token)
      return data
    } catch (error) {
      this.tokenStorage.clearToken()
      const message =
        error?.response?.data?.error_message ||
        error?.message ||
        'Login failed'
      throw new AuthError(message, { cause: error })
    }
  }

  logout() {
    this.tokenStorage.clearToken()
  }

  async checkAuth() {
    const { data } = await this.http.get(CHECK_PATH)
    return data
  }
}
