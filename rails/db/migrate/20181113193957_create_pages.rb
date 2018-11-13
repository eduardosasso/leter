class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.boolean :home
      t.integer :type, limit: 1
      t.belongs_to :site, foreign_key: true
      t.timestamps
    end
  end
end
