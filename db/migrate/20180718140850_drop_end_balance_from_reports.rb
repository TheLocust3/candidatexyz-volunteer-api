class DropEndBalanceFromReports < ActiveRecord::Migration[5.1]
  def change
    remove_column :reports, :ending_balance_cents
    remove_column :reports, :ending_balance_currency
  end
end
