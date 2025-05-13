module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    def new
      super
    end

    # POST /resource
    def create
      super
    end

    # PUT /resource
    def update
      super
    end

    # DELETE /resource
    def destroy
      super
    end

    protected

    def sign_up(_resource_name, _resource)
      true
    end

    def after_sign_up_path_for(_resource)
      new_user_session_path
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up,
                                        keys: %i[name birthday gender address role mobile email password])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update,
                                        keys: %i[username mobile email address gender password avatar])
    end

    def after_update_path_for(_resource)
      edit_user_registration_path
    end

    def update_resource(resource, params)
      resource.update(params)
    end
  end
end
