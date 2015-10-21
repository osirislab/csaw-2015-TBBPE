class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.last
  end
  helper_method :current_user

  def logged_in?
    !!current_user
  end
  helper_method :logged_in?

  def require_admin
    return render(status: 401, text: "auth failed") unless admin?
    session[:authed] = true
  end

  def admin?
    admin_authed_by_session? || admin_authed_by_token?
  end
  helper_method :admin?

  def admin_authed_by_session?
    session[:admin] == true
  end

  def admin_authed_by_token?
    Rack::Utils.secure_compare Rails.application.config.auth_token, params[:token].to_s
  end
end
