Spree::Adjustment.class_eval do
  default_scope :order => "FIELD(#{self.table_name}.originator_type, \"Spree::ShippingMethod\", \"Spree::PromotionAction\", \"Spree::TaxRate\", \"Spree::OrderCredit\") ASC"
  scope :store_credits, lambda { where(:originator_type => 'Spree::OrderCredit') }
end
