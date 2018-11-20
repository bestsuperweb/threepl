class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.float :first_unit1
      t.float :first_unit2
      t.float :first_unit3
      t.float :first_unit4
      t.float :first_unit5
      t.float :additional1
      t.float :additional2
      t.float :additional3
      t.float :additional4
      t.float :additional5
      t.float :packaging_cost1
      t.float :packaging_cost2
      t.float :packaging_cost3
      t.float :packaging_cost4
      t.float :packaging_cost5
      t.float :storage_cost1
      t.float :storage_cost2
      t.float :storage_cost3
      t.float :storage_cost4
      t.float :storage_cost5
      t.float :international_fee1
      t.float :international_fee2
      t.float :international_fee3
      t.float :international_fee4
      t.float :international_fee5
      t.string :warehousing_option1
      t.string :warehousing_option2
      t.string :warehousing_option3
      t.string :warehousing_option4
      t.string :warehousing_option5
      t.references :email, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
