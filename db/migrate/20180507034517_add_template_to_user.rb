class AddTemplateToUser < ActiveRecord::Migration
  def change
    add_column :users, :template, :string
  end
end
