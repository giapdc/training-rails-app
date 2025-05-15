require "rails_helper"

RSpec.describe Api::V1::Users::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user, password: "password123") }
  let(:valid_credentials) { { user: { email: user.email, password: "password123" } } }
  let(:invalid_credentials) { { user: { email: user.email, password: "wrongpassword" } } }
  let(:devise_mapping) { Devise.mappings[:user] }

  before do
    request.env["devise.mapping"] = devise_mapping
    allow(controller).to receive(:auth_options).and_return({ scope: :user })
  end

  describe "POST #create" do
    context "with valid credentials" do
      before do
        post :create, params: valid_credentials
      end

      it "returns http success" do
        expect(response).to have_http_status(:ok)
      end

      it "returns authentication token" do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:status][:token]).to be_present
      end

      it "returns token type" do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:status][:token_type]).to eq("Bearer")
      end

      it "returns user data" do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:status][:data][:user][:email]).to eq(user.email)
      end
    end

    context "with invalid credentials" do
      before do
        post :create, params: invalid_credentials
      end

      it "does not authenticate the user" do
        expect(controller.current_user).to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user) }

    context "when authenticated" do
      before do
        allow(controller).to receive(:current_user).and_return(user)
        delete :destroy
      end

      it "returns http ok" do
        expect(response).to have_http_status(:ok)
      end

      it "signs out the user" do
        expect(controller.current_user).to be(user)
      end
    end

    context "when not authenticated" do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
        delete :destroy
      end

      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
