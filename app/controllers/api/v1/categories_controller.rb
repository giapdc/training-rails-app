module Api
  module V1
    class CategoriesController < BaseController
      before_action :authenticate_user!
      before_action :set_category, only: %i[show update destroy]

      def index
        @categories = Category.search(params[:search])
                              .order(:name)
                              .page(params[:page] || 1)
                              .per(params[:per_page])
      end

      def show
        render :show, status: :ok
      end

      def create
        @category = Category.new(category_params)
        authorize! :create, @category
        if @category.save
          render :show, status: :created
        else
          render_error(@category.errors.full_messages)
        end
      end

      def update
        authorize! :update, @category
        if @category.update(category_params)
          render :show
        else
          render_error(@category.errors.full_messages)
        end
      end

      def destroy
        authorize! :destroy, @category
        if @category.destroy
          head :no_content
        else
          render_error("Failed to delete category")
        end
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.expect(category: %i[name description])
      end
    end
  end
end
