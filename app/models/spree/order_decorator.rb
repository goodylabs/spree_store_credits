# For some reason this decorator gets ran twice in testing, causing
# a stack level too deep error.
unless Spree::Order.method_defined?(:process_payments_with_credits!)
  Spree::Order.class_eval do
    attr_accessible :store_credit_amount, :remove_store_credits
    attr_accessor :store_credit_amount, :remove_store_credits

    after_save :ensure_sufficient_credit, :if => "self.user.present? && !self.completed?"
    has_one :order_credit, :class_name => "Spree::OrderCredit"

    validates_with StoreCreditMinimumValidator

    def process_payments_with_credits!
      if total > 0 && pending_payments.empty?
        false
      else
        process_payments_without_credits!
      end
    end
    alias_method_chain :process_payments!, :credits

    def store_credit_amount
      adjustments.store_credits.sum(:amount).abs.to_f
    end

    # in case of paypal payment, item_total cannot be 0
    def store_credit_maximum_amount
      item_total - 0.01
    end

    # returns the maximum usable amount of store credits
    def store_credit_maximum_usable_amount
      if user.store_credits_total > 0
        user.store_credits_total > store_credit_maximum_amount ? store_credit_maximum_amount : user.store_credits_total
      else
        0
      end
    end

    private

    # create store credit record
    def process_store_credit!
      if user.present?
        (order_credit || create_order_credit).create_or_update_credit_adjustment
      end
      true
    end
    state_machine.after_transition :to => :payment,  :do => :process_store_credit!

    def consume_users_credit
      return unless completed? and user.present?
      credit_used = self.store_credit_amount
      if credit_used > 0
        order_credit = self.order_credit || self.create_order_credit

        user.store_credits.available.each do |store_credit|
          if store_credit.remaining_amount > credit_used # Credit covers the rest of it
            order_credit.usages.create(
              :credit => store_credit,
              :amount => credit_used
            )
            store_credit.remaining_amount -= credit_used
            store_credit.save
            break
          else # Credit doesn't cover the whole amount
            credit_used -= store_credit.remaining_amount
            order_credit.usages.create(
              :credit => store_credit,
              :amount => store_credit.remaining_amount
            )

            store_credit.update_attribute(:remaining_amount, 0)
          end
        end
      end
    end
    # consume users store credit once the order has completed.
    state_machine.after_transition :to => :complete,  :do => :consume_users_credit

    # ensure that user has sufficient credits to cover adjustments
    #
    def ensure_sufficient_credit
      if user.store_credits_total < store_credit_amount
        # user's credit does not cover all adjustments.
        adjustments.store_credits.destroy_all
        update!
      end
    end

  end
end
