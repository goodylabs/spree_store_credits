class AddExpirationDateToSpreeStoreCredits < ActiveRecord::Migration
  def change
    add_column :spree_store_credits, :expiration_date, :datetime
  end
end
