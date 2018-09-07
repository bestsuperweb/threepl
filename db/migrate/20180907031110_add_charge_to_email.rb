class AddChargeToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :charge_id, :string
  end
end
