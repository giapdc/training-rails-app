module StripeService
  class CreateCustomer
    def self.call(user_id)
      user = User.find(user_id)
      return unless user.customers?

      create_and_assign_customer(user)
    rescue StandardError => e
      log_error(user_id, e)
      raise
    end

    def self.create_and_assign_customer(user)
      customer = Stripe::Customer.create({
                                           email: user.email,
                                           name: user.name,
                                           metadata: { user_id: user.id, role: user.role }
                                         })
      user.update!(stripe_customer_id: customer.id)
      Rails.logger.info("[StripeService::CreateCustomer] Successfully User ID=#{user.id}")
    end

    def self.log_error(user_id, error)
      message = "[StripeService::CreateCustomer] Failed User ID=#{user_id}: #{error.message}"
      Rails.logger.error(message)
    end
  end
end
