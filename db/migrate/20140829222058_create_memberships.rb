class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :team, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_index :memberships, [:team_id, :user_id], unique: true
  end
end
