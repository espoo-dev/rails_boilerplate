import { createApp } from 'vue'

// Mounts a composable inside a throwaway app so reactivity, lifecycle hooks, and
// inject() all work as they would in a real component.
//
// `provides` may be a plain object (string keys), a Map, or an array of
// [key, value] tuples — the array/Map forms are the way to pass Symbol keys,
// since Object.entries does not enumerate them.
//
// Usage:
//   const [result, app] = withSetup(() => useAuth(), {
//     plugins: [createPinia()],
//     provides: [[SERVICES_KEY, { authService }]],
//   })
//   // ...assert on result...
//   app.unmount()
export function withSetup(composable, { plugins = [], provides = {} } = {}) {
  let result
  const app = createApp({
    setup() {
      result = composable()
      return () => {}
    },
  })

  for (const plugin of plugins) app.use(plugin)

  const entries =
    provides instanceof Map
      ? [...provides.entries()]
      : Array.isArray(provides)
        ? provides
        : [
            ...Object.entries(provides),
            ...Object.getOwnPropertySymbols(provides).map((s) => [
              s,
              provides[s],
            ]),
          ]
  for (const [key, value] of entries) app.provide(key, value)

  app.mount(document.createElement('div'))
  return [result, app]
}
