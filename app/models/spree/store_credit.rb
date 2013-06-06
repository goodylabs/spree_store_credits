class Spree::StoreCredit < ActiveRecord::Base
  default_scope where("expiration_date IS NULL OR expiration_date > NOW()").order("expiration_date DESC")

  attr_accessible :user_id, :amount, :reason, :remaining_amount, :expiration_date

  validates :amount, :presence => true, :numericality => true
  validates :reason, :presence => true
  validates :user, :presence => true
  if Spree.user_class
    belongs_to :user, :class_name => Spree.user_class.to_s
  else
    belongs_to :user
    attr_accessible :amount, :remaining_amount, :reason, :user_id
  end
end
