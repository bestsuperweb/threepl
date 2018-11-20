class CreateShippingOptions < ActiveRecord::Migration
  def change
    create_table :shipping_options do |t|
      t.float :shipping_option1
      t.float :shipping_option2
      t.float :shipping_option3
      t.float :shipping_option4
      t.float :shipping_option5
      t.references :quote, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
