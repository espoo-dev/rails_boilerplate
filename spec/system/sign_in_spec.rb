require 'rails_helper'

RSpec.describe 'User sign in', type: :system do
  let(:user) { create(:user) }

  describe 'When data is valid' do
    it 'does log in' do
      visit '/users/sign_in'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_on 'Log in'

      expect(page).to have_current_path('/')
      expect(page).to have_text('Signed in successfully')
    end
  end

  describe 'When data is not valid' do
    it 'does not log in' do
      visit '/users/sign_in'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: "invalid password"

      click_on 'Log in'

      expect(page).to have_current_path('/users/sign_in')
    end
  end
end
