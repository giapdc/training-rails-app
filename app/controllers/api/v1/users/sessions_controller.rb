module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        include RackSessionFix
        respond_to :json
        skip_before_action :verify_authenticity_token
        skip_before_action :verify_signed_out_user

        def create
          self.resource = warden.authenticate!(auth_options)
          sign_in(resource_name, resource)

          token = request.env["warden-jwt_auth.token"]

          render json: {
            status: {
              code: 200,
              message: "Logged in successfully.",
              token: token,
              token_type: "Bearer",
              data: {
                user: UserSerializer.new(resource)
              }
            }
          }, status: :ok
        end

        def destroy
          unless current_user
            return render json: {
              status: 401,
              message: "Couldn't find an active session."
            }, status: :unauthorized
          end

          sign_out(resource_name)

          render json: {
            status: 200,
            message: "Logged out successfully"
          }, status: :ok
        end
      end
    end
  end
end
