class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.boolean :paid, default: false

      t.timestamps
    end
  end
end
