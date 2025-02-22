class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  skip_before_action :require_login, only: [:cart_link]

  private

  def logged_in?
    spree_current_user != nil
  end

  def require_login
    unless logged_in?
      flash[:error] = "Please Login or Sign Up"
      redirect_to spree_login_path
    end
  end
end
