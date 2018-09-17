class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :name, :string
    add_column :users, :company, :string
    add_column :users, :phone, :string
    add_column :users, :warehouse_locatoin, :string
    add_column :users, :admin, :boolean
  end
end
