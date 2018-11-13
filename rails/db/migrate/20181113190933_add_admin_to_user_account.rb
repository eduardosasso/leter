class AddAdminToUserAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :user_accounts, :admin, :boolean, default: false
  end
end
