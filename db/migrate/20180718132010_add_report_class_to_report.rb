class AddReportClassToReport < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :report_class, :string, default: 'finance', null: false
  end
end
