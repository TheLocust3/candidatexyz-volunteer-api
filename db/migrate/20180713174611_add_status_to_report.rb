class AddStatusToReport < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :status, :string, default: 'waiting', null: false
  end
end
