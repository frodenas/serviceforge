class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string     :name, null: false
      t.string     :description, null: false
      t.boolean    :bindable, null: false, default: true
      t.string     :tags
      t.boolean    :requires_syslog_drain, default: false
      t.string     :display_name
      t.attachment :image
      t.text       :long_description
      t.string     :provider
      t.string     :documentation_url
      t.string     :support_url
      t.string     :source_url
      t.integer    :license, null: false
      t.boolean    :public, null: false, default: true
      t.references :creator, null: false

      t.timestamps
    end

    add_index :services, :name, unique: true
    add_index :services, :public
  end
end
