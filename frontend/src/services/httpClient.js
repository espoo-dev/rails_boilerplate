import axios from 'axios'

export function createHttpClient({ baseURL, tokenProvider } = {}) {
  const instance = axios.create({ baseURL })

  instance.interceptors.request.use((config) => {
    const token = typeof tokenProvider === 'function' ? tokenProvider() : null
    if (token) {
      config.headers = config.headers || {}
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  })

  return instance
}
