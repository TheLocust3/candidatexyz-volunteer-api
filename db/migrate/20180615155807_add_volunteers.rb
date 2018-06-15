class AddVolunteers < ActiveRecord::Migration[5.1]
  def change
    create_table :volunteers, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string :email, null: false
      t.string :phone_number

      t.string :first_name, null: false
      t.string :last_name, null: false

      t.string :address
      t.string :zipcode, null: false
      t.string :city
      t.string :state

      t.text :help_blurb

      t.references :contact, type: :uuid, foreign_key: true, null: false

      t.timestamps
    end
  end
end
