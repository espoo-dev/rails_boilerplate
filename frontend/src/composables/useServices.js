import { inject } from 'vue'
import { SERVICES_KEY } from '@/services/keys'

export function useServices() {
  const services = inject(SERVICES_KEY, null)
  if (!services) {
    throw new Error(
      'No service container provided. Did you forget app.provide(SERVICES_KEY, ...)?',
    )
  }
  return services
}
