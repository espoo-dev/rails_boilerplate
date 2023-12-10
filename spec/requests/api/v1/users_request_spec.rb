# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users" do
  describe "GET /api/v1/users" do
    context "when user authenticated" do
      let(:token) { api_token(user) }

      context "when user is authorized" do
        let!(:user) { create(:user, admin: true) }

        context "when data is valid" do
          before do
            sign_in user
            get "/api/v1/users", params: {}
          end

          it { expect(response.parsed_body.first).to have_key("id") }
          it { expect(response.parsed_body.first).to have_key("email") }
          it { expect(response.parsed_body.first["email"]).to eq(user.email) }
          it { expect(response).to have_http_status(:ok) }
        end

        context "when has pagination via page and per_page" do
          let(:do_request) { get "/api/v1/users", params: }

          let(:json_response) { response.parsed_body }

          let(:params) do
            {
              page: 2,
              per_page: 5
            }
          end

          before do
            create_list(:user, 8)
            sign_in user
            do_request
          end

          it "returns only 4 users" do
            expect(json_response.length).to eq(4)
          end
        end
      end

      context "when user is unauthorized" do
        let!(:user) { create(:user) }

        before do
          sign_in user
          get "/api/v1/users", params: {}
        end

        it { expect(response).to have_http_status(:unauthorized) }

        it {
          expect(response.parsed_body["error"]).to eq("not allowed to index? this User::ActiveRecord_Relation")
        }
      end
    end

    context "when user unauthenticated" do
      context "when has user" do
        before do
          get "/api/v1/users"
        end

        it { expect(response).to have_http_status(:unauthorized) }

        it {
          expect(response.parsed_body["error"]).to eq("You need to sign in or sign up before continuing.")
        }
      end
    end
  end
end
