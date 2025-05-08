class ChangePriceToAmountInProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :amount_cents, :integer, default: 0, null: false
    add_column :products, :currency, :string, default: 'USD', null: false

    remove_column :products, :price, :decimal
  end
end
