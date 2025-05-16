require "rails_helper"

RSpec.describe Api::V1::CategoriesController, type: :request do
  let(:user) { create(:user, role: :admin) }
  let(:headers) do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }
  end

  describe "GET /api/v1/categories" do
    before { create_list(:category, 3) }

    it "returns categories" do
      get "/api/v1/categories", headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).not_to be_empty
    end
  end

  describe "POST /api/v1/categories" do
    let(:valid_params) { { category: { name: "Books", description: "All kinds of books" } } }
    let(:invalid_params) { { category: { name: "", description: "" } } }

    context "with valid params" do
      it "creates a new category" do
        post "/api/v1/categories", params: valid_params.to_json, headers: headers

        expect(response).to have_http_status(:created)
        expect(response.parsed_body["category"]["name"]).to eq(valid_params[:category][:name])
      end
    end

    context "with invalid params" do
      it "returns error" do
        post "/api/v1/categories", params: invalid_params.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["error"]).to be_present
      end
    end

    context "when user is not an admin" do
      let(:customer) { create(:user, role: :customers) }
      let(:headers) do
        token = Warden::JWTAuth::UserEncoder.new.call(customer, :user, nil).first
        {
          "Authorization" => "Bearer #{token}",
          "Content-Type" => "application/json",
          "ACCEPT" => "application/json"
        }
      end

      it "returns forbidden error" do
        post "/api/v1/categories", params: valid_params.to_json, headers: headers

        expect(response).to have_http_status(:forbidden)
        expect(response.parsed_body["error"]).to be_present
      end
    end
  end

  describe "PATCH /api/v1/categories/:id" do
    let(:category) { create(:category) }

    it "updates category with valid data" do
      patch "/api/v1/categories/#{category.id}",
            params: { category: { name: "Updated" } }.to_json,
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["category"]["name"]).to eq("Updated")
    end

    it "fails to update with invalid data" do
      patch "/api/v1/categories/#{category.id}",
            params: { category: { name: "" } }.to_json,
            headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /api/v1/categories/:id" do
    let(:category) { create(:category) }

    it "returns the category" do
      get "/api/v1/categories/#{category.id}", headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /api/v1/categories/:id" do
    let!(:category) { create(:category) }

    context "when user is not an admin" do
      let(:customer) { create(:user, role: :customers) }
      let(:headers) do
        token = Warden::JWTAuth::UserEncoder.new.call(customer, :user, nil).first
        {
          "Authorization" => "Bearer #{token}",
          "Content-Type" => "application/json",
          "ACCEPT" => "application/json"
        }
      end

      it "returns forbidden error" do
        delete "/api/v1/categories/#{category.id}", headers: headers

        expect(response).to have_http_status(:forbidden)
        expect(response.parsed_body["error"]).to be_present
      end
    end

    it "deletes the category" do
      expect do
        delete "/api/v1/categories/#{category.id}", headers: headers
      end.to change(Category, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
