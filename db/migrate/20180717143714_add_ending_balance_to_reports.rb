class AddEndingBalanceToReports < ActiveRecord::Migration[5.1]
  def change
    change_table :reports do |t|
      t.monetize :ending_balance, default: 0
    end
  end
end
