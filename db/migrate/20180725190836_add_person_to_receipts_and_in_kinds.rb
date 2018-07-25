class AddPersonToReceiptsAndInKinds < ActiveRecord::Migration[5.1]
  def change
    add_column :receipts, :person, :string, default: 'individual', null: false
    add_column :in_kinds, :person, :string, default: 'individual', null: false
  end
end
