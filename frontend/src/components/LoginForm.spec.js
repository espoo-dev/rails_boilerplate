import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import LoginForm from './LoginForm.vue'

describe('LoginForm', () => {
  it('renders email and password fields and a submit button', () => {
    const wrapper = mount(LoginForm)
    expect(wrapper.find('input#email').exists()).toBe(true)
    expect(wrapper.find('input#password').exists()).toBe(true)
    expect(wrapper.find('button[type="submit"]').exists()).toBe(true)
  })

  it('emits submit with the current credentials when the form is submitted', async () => {
    const wrapper = mount(LoginForm)
    await wrapper.find('input#email').setValue('user@example.com')
    await wrapper.find('input#password').setValue('secret')
    await wrapper.find('form').trigger('submit.prevent')

    const events = wrapper.emitted('submit')
    expect(events).toHaveLength(1)
    expect(events[0][0]).toEqual({
      email: 'user@example.com',
      password: 'secret',
    })
  })

  it('shows the error message when the error prop is set', () => {
    const wrapper = mount(LoginForm, {
      props: { error: 'Invalid credentials' },
    })
    const errorEl = wrapper.get('[data-testid="login-error"]')
    expect(errorEl.text()).toBe('Invalid credentials')
  })

  it('does not render an error element when error is null', () => {
    const wrapper = mount(LoginForm, { props: { error: null } })
    expect(wrapper.find('[data-testid="login-error"]').exists()).toBe(false)
  })

  it('disables the submit button while loading', () => {
    const wrapper = mount(LoginForm, { props: { loading: true } })
    const button = wrapper.get('button[type="submit"]')
    expect(button.attributes('disabled')).toBeDefined()
    expect(button.text()).toContain('Signing in')
  })
})
