class AddDataToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :data, :json, default: {}, null: false

    remove_column :reports, :beginning_date
    remove_column :reports, :ending_date
  end
end
