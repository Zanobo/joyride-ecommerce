require 'acumatica/synchronizer'

Spree::UsersController.class_eval do
  def show
    @orders = Acumatica::Synchronizer.new.get_customer_orders('TWITTER')
  end

  def update
    @user.ship_address.update!(address_params)
  rescue ActiveRecord::ReadOnlyRecord
    Acumatica::Synchronizer.new.export_address(@user.company_name, address_params)
    redirect_to account_path
  rescue ActiveRecord::RecordInvalid => e
    @user.errors.add(:base, e.message)
    render :edit
  end

  private

  def address_params
    params.require(:address).permit(:address1, :address2, :city, :zipcode,
                                    :phone, :country_id, :state_id)
  end
end
