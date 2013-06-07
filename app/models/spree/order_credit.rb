class Spree::OrderCredit < ActiveRecord::Base
  belongs_to :order, :class_name => "Spree::Order"
  has_many :usages, :class_name => "Spree::OrderCreditUsage"

  def create_or_update_credit_adjustment
    amount = adjustment_amount

    if adj = order.adjustments.store_credits.first
      adj.update_attribute(:amount, amount)

    elsif amount < 0 # credits are negative
      # create adjustment off association to prevent reload
      order.adjustments.store_credits.create({
        :source => order,
        :originator => self,
        :label => I18n.t(:store_credit),
        :amount => amount
      }, :without_protection => true)
    end

  end

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

end

