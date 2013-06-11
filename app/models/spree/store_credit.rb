class Spree::StoreCredit < ActiveRecord::Base
  default_scope where("expiration_date IS NULL OR expiration_date > NOW()").order("expiration_date")

  attr_accessible :user_id, :amount, :reason, :remaining_amount, :expiration_date, :email, :issued_on

  validates :amount, :presence => true, :numericality => true
  validates :reason, :presence => true
  #validates :user, :presence => true # allow pending credits, require email instead
  validates :email, :presence => true

  if Spree.user_class
    belongs_to :user, :class_name => Spree.user_class.to_s
  else
    belongs_to :user
    attr_accessible :amount, :remaining_amount, :reason, :user_id
  end

  def used?
    remaining_amount <= 0
  end

  def expired?
    expiration_date.try(:past?)
  end

  def unavailable?
    used? || expired?
  end

  def available?
    !unavailable?
  end

end
