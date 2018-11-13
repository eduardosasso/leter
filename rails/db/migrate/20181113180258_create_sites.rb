class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.string :domain
      t.boolean :subdomain
      t.belongs_to :account

      t.timestamps
    end
  end
end
