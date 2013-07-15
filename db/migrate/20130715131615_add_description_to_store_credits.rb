class AddDescriptionToStoreCredits < ActiveRecord::Migration
  def change
    add_column :spree_store_credits, :description, :text
  end
end
