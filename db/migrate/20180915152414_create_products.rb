class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :weight
      t.float :width
      t.float :length
      t.float :height
      t.string :image
      t.boolean :has_battery
      t.float :shipping_volume
      t.integer :order_quantity
      t.text :notes
      t.references :email, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
