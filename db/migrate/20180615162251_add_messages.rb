class AddMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :subject, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
