class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_home_breadcrumb
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  protected

  def set_home_breadcrumb
    add_breadcrumb '<i class="icon-home"></i>Home'.html_safe, root_url
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :email, :public, :password, :password_confirmation, :current_password) }
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = I18n.t "pundit.#{policy_name}.#{exception.query}", default: 'You are not authorized to perform this action'
    redirect_to(request.referrer || root_url)
  end
end
