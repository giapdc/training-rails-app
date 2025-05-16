require "rails_helper"

RSpec.describe StripeService::CreateCustomer do
  let(:customer) { create(:user, role: :customers) }
  let(:logger) { instance_double(Logger) }

  before do
    allow(Rails).to receive(:logger).and_return(logger)
  end

  describe ".call" do
    context "when Stripe::Customer.create succeeds" do
      let(:stripe_customer) { instance_double(Stripe::Customer, id: "cus_12345") }
      let(:message) { "[StripeService::CreateCustomer] Successfully User ID=#{customer.id}" }

      before do
        allow(User).to receive(:find).with(customer.id).and_return(customer)
        allow(Stripe::Customer).to receive(:create).with(hash_including(
                                                           email: customer.email,
                                                           name: customer.name,
                                                           metadata: {
                                                             user_id: customer.id,
                                                             role: customer.role
                                                           }
                                                         )).and_return(stripe_customer)
        allow(customer).to receive(:update!)
        allow(logger).to receive(:info)
      end

      it "creates a Stripe customer, updates and logs info" do
        described_class.call(customer.id)

        expect(customer).to have_received(:update!).with(stripe_customer_id: stripe_customer.id)
        expect(logger).to have_received(:info).with(message)
      end
    end

    context "when Stripe::Customer.create raises an error" do
      before do
        allow(Stripe::Customer).to receive(:create).and_raise(StandardError.new("Stripe error"))
        allow(User).to receive(:find).with(customer.id).and_return(customer)
        allow(logger).to receive(:error)
      end

      it "logs error and raises the exception" do
        expect { described_class.call(customer.id) }.to raise_error(StandardError, "Stripe error")
        expect(logger).to have_received(:error).with(/Failed User ID=#{customer.id}: Stripe error/)
      end
    end
  end
end
