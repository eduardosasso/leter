class CreateUserAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_accounts do |t|
      t.references :user, foreign_key: true
      t.belongs_to :account, foreign_key: true
      t.timestamps
    end
  end
end
