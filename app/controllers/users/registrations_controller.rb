class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      render status: 200,
      json: {
        success: true, info: "Registered", data: {
          user: resource,
          auth_token: resource.authentication_token
        }
      }
    else
      render status: :unprocessable_entity,
      json: {
        success: false,
        info: resource.errors, data: {}
      }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :mobile)
  end

end
