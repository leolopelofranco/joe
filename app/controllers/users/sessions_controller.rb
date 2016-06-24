class Users::SessionsController < DeviseController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, except: [:create]
  respond_to :json

  def create
    resource = User.find_for_database_authentication(email: params[:user][:email])
    return failure unless resource
    return failure unless resource.valid_password?(params[:user][:password])
    render status: 200,
      json: {
        success: true, info: "Logged in", data: {
          user: resource,
          auth_token: resource.authentication_token
        }
      }
  end

  def fb_login
    resource = User.find_by_uid(params[:user][:authResponse][:userID])
    return failure unless resource
    render status: 200,
      json: {
        success: true, info: "Logged in", data: {
          user: resource,
          auth_token: resource.authentication_token
        }
      }
  end

  def destroy
    resource = User.find_for_database_authentication(id: params[:user_id])
    return failure unless resource
    resource.clear_authentication_token
    render status: 200,
      json: {
        success: true, info: "Logged out"
      }
  end

  def update_password
    @user = User.find(params[:user_id])
    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:password, :password_confirmation)
  end

  def failure
    warden.custom_failure!
    render status: 401,
      json: {
        success: false, info: "Login failed", data: {}
      }
  end
end
