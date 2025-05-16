module Customers
  class CreateStripeCustomerWorker
    include Sidekiq::Worker
    sidekiq_options queue: :stripe

    def perform(user_id)
      StripeService::CreateCustomer.call(user_id)
    rescue StandardError => e
      Rails.logger.error("Stripe create customer failed: #{e.message}")
      raise e
    end
  end
end
