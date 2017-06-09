require 'acumatica/synchronizer'

Spree::UsersController.class_eval do
  def show
    @orders = Acumatica::Synchronizer.new.get_customer_orders('TWITTER')
  end
end
