class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.text :products
      t.string :partners
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
