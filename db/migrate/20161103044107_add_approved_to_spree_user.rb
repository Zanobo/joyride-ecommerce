class AddApprovedToSpreeUser < ActiveRecord::Migration[5.0]
  def self.up
    add_column :spree_users, :approved, :boolean, :default => false, :null => false
    add_index  :spree_users, :approved
  end

  def self.down
    remove_index  :spree_users, :approved
    remove_column :spree_users, :approved
  end
end
