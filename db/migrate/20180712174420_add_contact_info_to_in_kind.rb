class AddContactInfoToInKind < ActiveRecord::Migration[5.1]

  def change
    add_column :in_kinds, :email, :string
    add_column :in_kinds, :phone_number, :string
  end
end
