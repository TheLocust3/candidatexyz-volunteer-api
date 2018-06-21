class AddCampaignId < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :campaign_id, :string, null: false
    add_column :messages, :campaign_id, :string, null: false
    add_column :volunteers, :campaign_id, :string, null: false
  end
end
