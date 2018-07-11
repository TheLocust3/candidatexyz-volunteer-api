class UpdateDonors < ActiveRecord::Migration[5.1]
  def change
    rename_table :donors, :receipts
  end
end
