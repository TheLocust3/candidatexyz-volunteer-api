class RemoveZipcodeFromReceipts < ActiveRecord::Migration[5.1]
  def change
    remove_column :receipts, :zipcode
    add_column :receipts, :country, :string
  end
end
