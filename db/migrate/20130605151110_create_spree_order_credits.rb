class CreateSpreeOrderCredits < ActiveRecord::Migration
  def change
    create_table :spree_order_credits do |t|
      t.integer :order_id
      t.timestamps
    end
    add_index :spree_order_credits, :order_id
  end
end
