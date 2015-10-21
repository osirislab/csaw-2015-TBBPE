class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    return @current_user if defined? @current_user
    @current_user = User.find_by_id session[:user_id]
  end
  helper_method :current_user

  def logged_in?
    !!current_user
  end
  helper_method :logged_in?

  def access_denied
    render(status: 401, text: "access denied")
  end

  def authenticated_only
    access_denied unless logged_in?
  end

  def anonymous_only
    access_denied if logged_in?
  end

  def require_admin
    if admin?
      session[:authed] = true
    else
      access_denied
    end
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
