class CreateEtemplates < ActiveRecord::Migration
  def change
    create_table :etemplates do |t|
      t.string :template_id
      t.string :template_name

      t.timestamps null: false
    end
  end
end
