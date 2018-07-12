class CreateInKind < ActiveRecord::Migration[5.1]
  def change
    create_table :in_kinds, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string :from_whom, null: false
      t.string :description, null: false

      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :country, null: false
      
      t.datetime :date_received, null: false

      t.monetize :value, default: 0, null: false

      t.string :campaign_id, null: false

      t.timestamps
    end
  end
end
