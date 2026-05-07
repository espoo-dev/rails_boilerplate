# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions" do
  describe "POST /users/sign_in" do
    let(:password) { "password" }

    context "when the user is an admin" do
      let(:user) { create(:user, admin: true, password: password) }

      before do
        post user_session_path, params: { user: { email: user.email, password: password } }
      end

      it { expect(response).to redirect_to(admin_root_path) }
    end

    context "when the user is not an admin" do
      let(:user) { create(:user, password: password) }

      before do
        post user_session_path, params: { user: { email: user.email, password: password } }
      end

      it { expect(response).not_to redirect_to(admin_root_path) }
    end
  end
end
