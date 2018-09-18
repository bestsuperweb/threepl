class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops  do |t|
      t.string :shopify_domain, null: false
      t.string :shopify_token, null: false
      t.string :shop_name
      t.string :owner_email
      t.timestamps
    end

    add_index :shops, :shopify_domain, unique: true
  end

  def self.down
    drop_table :shops
  end
end
