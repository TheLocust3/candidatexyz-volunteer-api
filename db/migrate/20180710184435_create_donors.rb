class CreateDonors < ActiveRecord::Migration[5.1]
  def change
    create_table :donors do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :zipcode, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.datetime :date_received, null: false

      t.string :occupation, default: ''
      t.string :employer, default: ''

      t.monetize :amount, default: 0, null: false

      t.string :campaign_id, null: false

      t.timestamps
    end
  end
end
