RSpec.shared_context "when user is not authenticated" do
  before do
    get "/api/v1/private_method"
  end

  it "renders json with message" do
    expect(response.body).to include("error", "Invalid token")
  end

  it "receives http status unauthorized" do
    expect(response).to have_http_status(:unauthorized)
  end
end
