class CreateServicePlans < ActiveRecord::Migration
  def change
    create_table :service_plans do |t|
      t.references :service, null: false
      t.string     :name, null: false
      t.string     :description, null: false
      t.boolean    :free, default: true
      t.string     :bullets
      t.string     :display_name
      t.boolean    :public, null: false, default: true
      t.references :creator, null: false

      t.timestamps
    end

    add_index :service_plans, [:service_id, :name], unique: true
    add_index :service_plans, :public
  end
end
