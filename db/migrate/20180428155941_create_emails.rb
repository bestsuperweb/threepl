class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :status
      t.references :user, index: true, foreign_key: true
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
