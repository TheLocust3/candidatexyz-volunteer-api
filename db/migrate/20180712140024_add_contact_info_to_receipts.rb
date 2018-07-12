class AddContactInfoToReceipts < ActiveRecord::Migration[5.1]

  def change
    add_column :receipts, :email, :string
    add_column :receipts, :phone_number, :string
    add_column :receipts, :receipt_type, :string, default: 'donation', null: false
  end
end
