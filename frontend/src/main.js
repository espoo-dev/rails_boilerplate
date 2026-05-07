import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import { createServiceContainer } from './services/container'
import { SERVICES_KEY } from './services/keys'

const app = createApp(App)

app.provide(SERVICES_KEY, createServiceContainer())
app.use(createPinia())
app.use(router)

app.mount('#app')
