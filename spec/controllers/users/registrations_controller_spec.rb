require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:devise_mapping) { Devise.mappings[:user] }
  let(:user) { create(:user) }
  let(:valid_signup_params) do
    {
      name: "Test User",
      email: Faker::Internet.email,
      password: "password123",
      password_confirmation: "password123",
      birthday: Faker::Date.between(from: "1950/01/01", to: "2001/12/31"),
      gender: "male",
      address: Faker::Address.full_address,
      role: "admin"
    }
  end
  let(:valid_update_params) do
    {
      name: "Updated User",
      email: Faker::Internet.email,
      address: Faker::Address.full_address,
      gender: "female"
    }
  end

  before do
    request.env["devise.mapping"] = devise_mapping
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new user" do
        expect do
          post :create, params: { user: valid_signup_params }
        end.to change(User, :count).by(1)
      end

      it "redirects to login page" do
        post :create, params: { user: valid_signup_params }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with invalid params" do
      it "does not create user" do
        expect do
          post :create, params: { user: valid_signup_params.merge(email: "") }
        end.not_to change(User, :count)
      end
    end
  end

  describe "PUT #update" do
    before { sign_in user }

    context "with valid params" do
      it "updates user attributes" do
        put :update, params: { user: valid_update_params }
        user.reload
        expect(user.email).to eq(valid_update_params[:email])
      end

      it "redirects to edit profile page" do
        put :update, params: { user: valid_update_params }
        expect(response).to redirect_to(edit_user_registration_path)
      end
    end

    context "with invalid params" do
      it "does not update with invalid email" do
        put :update, params: { user: valid_update_params.merge(email: "") }
        expect(response).not_to be_redirect
      end
    end
  end

  describe "DELETE #destroy" do
    before { sign_in user }

    it "destroys the user" do
      expect do
        delete :destroy
      end.to change(User, :count).by(-1)
    end

    it "redirects to root path" do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end

  describe "Parameter sanitization" do
    it "permits sign up parameters" do
      params = ActionController::Parameters.new(user: valid_signup_params)
      controller.params = params

      controller.send(:devise_parameter_sanitizer)
      controller.send(:configure_sign_up_params)

      permitted_params = controller.params.require(:user).permit!
      expect(permitted_params.keys.map(&:to_sym)).to include(
        :name, :birthday, :gender, :address, :role, :email, :password
      )
    end

    it "permits account update parameters" do
      params = ActionController::Parameters.new(user: valid_update_params)
      controller.params = params

      controller.send(:devise_parameter_sanitizer)
      controller.send(:configure_account_update_params)

      permitted_params = controller.params.require(:user).permit!
      expect(permitted_params.keys.map(&:to_sym)).to include(
        :name, :email, :address, :gender
      )
    end
  end
end
