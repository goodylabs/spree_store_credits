class Spree::OrderCreditUsage < ActiveRecord::Base
  attr_accessible :amount, :credit, :credit_id, :order_credit, :order_credit_id
  belongs_to :credit, :class_name => "Spree::StoreCredit"
  belongs_to :order_credit, :class_name => "Spree::OrderCredit"
end
