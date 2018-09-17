class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.float :pp_fee
      t.float :storage_cost
      t.float :international_fee
      t.string :shipping_option
      t.string :warehousing_option
      t.references :email, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
