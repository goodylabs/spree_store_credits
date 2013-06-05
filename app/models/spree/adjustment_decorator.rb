Spree::Adjustment.class_eval do
  scope :store_credits, lambda { where(:originator_type => 'Spree::OrderCredit') }
end
