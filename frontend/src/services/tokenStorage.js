const TOKEN_KEY = 'token'

export function createTokenStorage(storage = window.localStorage) {
  return {
    getToken() {
      return storage.getItem(TOKEN_KEY)
    },
    setToken(token) {
      storage.setItem(TOKEN_KEY, token)
    },
    clearToken() {
      storage.removeItem(TOKEN_KEY)
    },
  }
}
