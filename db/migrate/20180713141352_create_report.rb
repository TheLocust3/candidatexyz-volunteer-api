class CreateReport < ActiveRecord::Migration[5.1]
  def change
    create_table :reports, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string :report_type, null: false

      t.datetime :beginning_date, null: false
      t.datetime :ending_date, null: false

      t.string :campaign_id, null: false

      t.timestamps
    end
  end
end
