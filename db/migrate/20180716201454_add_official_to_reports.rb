class AddOfficialToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :official, :boolean, default: false, null: false
  end
end
