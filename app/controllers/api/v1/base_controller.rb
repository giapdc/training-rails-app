module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from CanCan::AccessDenied, with: :handle_access_denied
      skip_before_action :verify_authenticity_token
      respond_to :json

      def render_success(data, status: :ok)
        render json: {
          status: status,
          data: data
        }, status: status
      end

      def render_error(message, status: :unprocessable_entity)
        render json: {
          status: status,
          error: message
        }, status: status
      end

      def render_not_found(exception)
        render_error(exception.message, status: :not_found)
      end

      def handle_access_denied(_exception)
        render json: {
          status: 403,
          error: "You do not have permission to perform this action"
        }, status: :forbidden
      end
    end
  end
end
