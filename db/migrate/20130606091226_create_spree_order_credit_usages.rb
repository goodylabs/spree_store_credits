class CreateSpreeOrderCreditUsages < ActiveRecord::Migration
  def change
    create_table :spree_order_credit_usages do |t|
      t.integer :order_credit_id
      t.integer :credit_id
      t.decimal :amount, :precision => 8, :scale => 2
      t.timestamps
    end
    add_index :spree_order_credit_usages, :order_credit_id
  end
end
