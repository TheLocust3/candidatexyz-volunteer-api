class AddZipcodeToCommittee < ActiveRecord::Migration[5.1]
  def change
    add_column :committees, :zipcode, :string
  end
end
