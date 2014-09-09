class CreateGrants < ActiveRecord::Migration
  def change
    create_table :grants do |t|
      t.references :team, null: false
      t.references :resource, null: false, polymorphic: true

      t.timestamps
    end

    add_index :grants, [:team_id, :resource_id, :resource_type], unique: true
  end
end
