class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :access_level, null: false

      t.timestamps
    end

    add_index :teams, :name, unique: true
  end
end
