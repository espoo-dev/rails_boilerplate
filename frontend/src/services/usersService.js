const USERS_PATH = '/api/v1/users'

export class UsersService {
  constructor({ http }) {
    if (!http) throw new Error('UsersService requires an http client')
    this.http = http
  }

  async list() {
    const { data } = await this.http.get(USERS_PATH)
    return data
  }
}
