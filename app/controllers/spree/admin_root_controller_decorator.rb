Spree::Admin::RootController.class_eval do
  skip_before_action :require_login

end