module Spree
  class Admin::StoreCreditsController < Admin::ResourceController
    before_filter :check_amounts, :only => [:edit, :update]
    prepend_before_filter :set_remaining_amount, :only => [:create, :update]

    def create
      if params[:emails]
        # Mass-credits assignment

        emails = params[:emails].split(/\s+/)
        users = Spree::User.where(:email => emails)

        # Assign to existing users
        users.each do |u|
          credit_params = params[:store_credit].dup
          credit_params[:email] = u.email
          credit_params[:issued_on] = DateTime.now
          u.store_credits.create credit_params
        end

        # Create pending credits
        user_emails = users.collect(&:email)
        (emails - user_emails).each do |email|
          unless email.blank?
            credit_params = params[:store_credit].dup
            credit_params[:email] = email
            Spree::StoreCredit.create credit_params
          end
        end

        redirect_to :admin_store_credits

      else
        # Add credit to single user
        super
      end
    end

    private
    def check_amounts
      if (@store_credit.remaining_amount < @store_credit.amount)
        flash[:error] = I18n.t(:cannot_edit_used)
        redirect_to admin_store_credits_path
      end
    end

    def set_remaining_amount
      params[:store_credit][:remaining_amount] = params[:store_credit][:amount]
    end

    def collection
      super.page(params[:page])
    end
  end
end
