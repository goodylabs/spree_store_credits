Spree::AppConfiguration.class_eval do
  preference :use_store_credit_minimum, :float, :default => 10.0
end
