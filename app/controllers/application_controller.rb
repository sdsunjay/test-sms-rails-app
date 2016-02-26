class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_devise_params, if: :devise_controller?
  #before_filter :ensure_signup_complete
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :phone_number, :pin, :email, :password, :password_confirmation)
    end
  end
  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # phone hasn't been verified yet
    if current_user && !current_user.phone_number_verified
      redirect_to finish_signup_path(current_user)
    end
  end
end
