class AddPriceClassToSpreeUser < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_users, :price_class, :string
  end
end
