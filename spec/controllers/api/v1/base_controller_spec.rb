require "rails_helper"

RSpec.describe Api::V1::BaseController, type: :controller do
  include Devise::Test::ControllerHelpers

  controller(described_class) do
    def success_action
      render_success({ message: "Success!" }, status: :ok)
    end

    def error_action
      render_error("Something went wrong", status: :unprocessable_entity)
    end

    def not_found_action
      raise ActiveRecord::RecordNotFound, "Record not found"
    end
  end

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)

    routes.draw do
      get "success_action" => "api/v1/base#success_action"
      get "error_action" => "api/v1/base#error_action"
      get "not_found_action" => "api/v1/base#not_found_action"
    end
  end

  describe "GET #success_action" do
    it "returns a success JSON response" do
      get :success_action, format: :json
      expect(response).to have_http_status(:ok)

      json = response.parsed_body
      expect(json["status"]).to eq("ok")
      expect(json["data"]).to eq({ "message" => "Success!" })
    end
  end

  describe "GET #error_action" do
    it "returns an error JSON response" do
      get :error_action, format: :json
      expect(response).to have_http_status(:unprocessable_entity)

      json = response.parsed_body
      expect(json["status"]).to eq("unprocessable_entity")
      expect(json["error"]).to eq("Something went wrong")
    end
  end

  describe "GET #not_found_action" do
    it "returns a not_found JSON response" do
      get :not_found_action, format: :json
      expect(response).to have_http_status(:not_found)

      json = response.parsed_body
      expect(json["status"]).to eq("not_found")
      expect(json["error"]).to eq("Record not found")
    end
  end
end
