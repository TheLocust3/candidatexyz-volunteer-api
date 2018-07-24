class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.boolean :read, default: false

      t.string :user_id, null: false
      t.string :campaign_id, null: false

      t.timestamps
    end
  end
end
