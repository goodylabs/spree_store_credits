class Spree::OrderCredit < ActiveRecord::Base
  belongs_to :order, :class_name => "Spree::Order"
  after_create :create_credit_adjustment

  def update_adjustment(adjustment, source)
    adjustment.update_attribute_without_callbacks :amount, adjustment_amount
  end

  protected
  def adjustment_amount
    if order.user.nil?
      amount = 0
    else 
      order.update_totals
      amount = [order.user.store_credits_total, (order.total + order.store_credit_amount.abs)].min
      amount *= -1 # credit decreases the total
    end
    amount
  end

  def create_credit_adjustment

    # create adjustment off association to prevent reload
    order.adjustments.store_credits.create({
      :source => order,
      :originator => self,
      :label => I18n.t(:store_credit),
      :amount => adjustment_amount
    }, :without_protection => true)

    true
  end

end

