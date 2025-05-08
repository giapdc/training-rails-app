class ChangePriceToAmountInOrderItems < ActiveRecord::Migration[8.0]
  def change
    add_column :order_items, :amount_cents, :integer, default: 0, null: false
    add_column :order_items, :currency, :string, default: 'USD', null: false

    remove_column :order_items, :price, :decimal
  end
end
