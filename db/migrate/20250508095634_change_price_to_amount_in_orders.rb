class ChangePriceToAmountInOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :total_amount_cents, :integer, default: 0, null: false
    add_column :orders, :currency, :string, default: 'USD', null: false

    remove_column :orders, :total_price, :decimal
  end
end
