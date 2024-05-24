
<script>
import { ref } from 'vue'

export default {
  setup() {
    // state
    const username = ref("user@email.com")
    const password = ref("password")

    // methods
    const doLogin = () => {
      console.log(`${username.value} , ${password.value}`)
    }

    return {
      username,
      password,
      doLogin
    }
  },
}
</script>

<template>
  <div class="login">
    <h2>Login</h2>
    <form @submit.prevent="">
      <div>
        <label for="username">Username:</label>
        <input type="text" id="username" v-model="username" required />
      </div>
      <div>
        <label for="password">Password:</label>
        <input type="password" id="password" v-model="password" required />
      </div>
      <button @click="doLogin">Login</button>
    </form>
  </div>
</template>
