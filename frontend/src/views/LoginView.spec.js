import { describe, it, expect, vi, beforeEach } from 'vitest'
import { ref } from 'vue'
import { mount } from '@vue/test-utils'

const useAuthMock = vi.fn()

vi.mock('@/composables/useAuth', () => ({
  useAuth: () => useAuthMock(),
}))

import LoginView from './LoginView.vue'
import LoginForm from '@/components/LoginForm.vue'

function buildAuthStub({
  isAuthenticated = false,
  isLoading = false,
  error = null,
  login = vi.fn(),
} = {}) {
  return {
    isAuthenticated: ref(isAuthenticated),
    isLoading: ref(isLoading),
    error: ref(error),
    login,
  }
}

describe('LoginView', () => {
  beforeEach(() => {
    useAuthMock.mockReset()
  })

  it('renders the LoginForm when not authenticated', () => {
    useAuthMock.mockReturnValue(buildAuthStub())
    const wrapper = mount(LoginView)
    expect(wrapper.findComponent(LoginForm).exists()).toBe(true)
    expect(wrapper.find('[data-testid="login-success"]').exists()).toBe(false)
  })

  it('forwards loading and error from the composable to the form', () => {
    useAuthMock.mockReturnValue(
      buildAuthStub({ isLoading: true, error: 'nope' }),
    )
    const wrapper = mount(LoginView)
    const form = wrapper.findComponent(LoginForm)
    expect(form.props('loading')).toBe(true)
    expect(form.props('error')).toBe('nope')
  })

  it('calls login(email, password) when the form emits submit', async () => {
    const login = vi.fn().mockResolvedValue({ token: 'abc' })
    useAuthMock.mockReturnValue(buildAuthStub({ login }))
    const wrapper = mount(LoginView)

    await wrapper.findComponent(LoginForm).vm.$emit('submit', {
      email: 'a@b.com',
      password: 'pw',
    })

    expect(login).toHaveBeenCalledWith('a@b.com', 'pw')
  })

  it('swallows login rejections so the unhandled promise warning never fires', async () => {
    const login = vi.fn().mockRejectedValue(new Error('boom'))
    useAuthMock.mockReturnValue(buildAuthStub({ login }))
    const wrapper = mount(LoginView)

    await wrapper.findComponent(LoginForm).vm.$emit('submit', {
      email: 'a@b.com',
      password: 'pw',
    })

    expect(login).toHaveBeenCalled()
  })

  it('shows the success message and hides the form when authenticated', () => {
    useAuthMock.mockReturnValue(buildAuthStub({ isAuthenticated: true }))
    const wrapper = mount(LoginView)
    expect(wrapper.find('[data-testid="login-success"]').exists()).toBe(true)
    expect(wrapper.findComponent(LoginForm).exists()).toBe(false)
  })
})
