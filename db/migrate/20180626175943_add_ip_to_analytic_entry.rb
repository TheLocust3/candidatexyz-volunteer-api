class AddIpToAnalyticEntry < ActiveRecord::Migration[5.1]
  def change
    add_column :analytic_entries, :ip, :string
  end
end
