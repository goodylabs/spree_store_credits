if Spree.user_class
  Spree.user_class.class_eval do
    has_many :store_credits, :class_name => "Spree::StoreCredit"

    after_create :apply_pending_credits

    def has_store_credit?
      store_credits.present?
    end

    def store_credits_total
      store_credits.available.sum(:remaining_amount)
    end

    protected
    def apply_pending_credits
      Spree::StoreCredit.where(:email => email, :issued_on => nil).each do |credit|
        credit.user = self
        credit.issued_on = DateTime.now
        credit.save
      end
    end

  end
end
