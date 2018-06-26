class CreateAnalyticEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :analytic_entries, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.json :payload, null: false
      t.string :campaign_id, null: false

      t.timestamps
    end
  end
end
