class AddEmailCreatorAndIssuedOnToSpreeStoreCredits < ActiveRecord::Migration
  def change
    add_column :spree_store_credits, :email, :string
    add_column :spree_store_credits, :creator_id, :int
    add_column :spree_store_credits, :issued_on, :datetime
    add_index :spree_store_credits, :email
  end
end
