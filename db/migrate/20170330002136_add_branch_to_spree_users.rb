class AddBranchToSpreeUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_users, :branch, :string
  end
end
