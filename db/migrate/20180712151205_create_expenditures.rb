class CreateExpenditures < ActiveRecord::Migration[5.1]
  def change
    create_table :expenditures, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string :paid_to, null: false
      t.string :purpose, null: false
      
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :country, null: false
      t.datetime :date_paid, null: false

      t.monetize :amount, default: 0, null: false

      t.string :campaign_id, null: false

      t.timestamps
    end
  end
end
