
<script>
import { ref } from 'vue'
import { doLoginApi } from "../services/authApi";
import { getUsersApi } from "../services/usersApi";

export default {
  setup() {
    // state
    const username = ref("admin@email.com")
    const password = ref("password")

    // methods
    const doLogin = () => {
      doLoginApi(username.value, password.value).then(
        (result) => {
          localStorage.token = result.data.token;

          getUsersApi()
        },
        (error) => {
          console.error(error.response.data.error_message);
        }
      );
    }

    return {
      username,
      password,
      doLogin,
      doLoginApi
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
