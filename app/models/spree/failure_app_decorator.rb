Devise::FailureApp.class_eval do

  # You need to override respond to eliminate recall
  def respond
    @user = Spree::User.find_by_email(params[:spree_user][:email])
    if http_auth?
      http_auth
    elsif @user.approved != true
      flash[:notice] = "You have signed up successfully but your account has not been approved by your administrator yet"
      redirect_to spree.login_path
    else
      redirect_to spree.login_path
    end
  end
end