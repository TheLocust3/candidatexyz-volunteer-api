class AddContacts < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'uuid-ossp'

    create_table :contacts, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.string :zipcode
      t.string :phone_number

      t.timestamps
    end
  end
end
