require "rails_helper"

RSpec.describe Customers::CreateStripeCustomerWorker, type: :worker do
  subject(:worker) { described_class.new }

  let(:admin) { create(:user, role: :admin) }
  let(:customer) { create(:user, role: :customers) }
  let(:stripe_customer_double) { instance_double(Stripe::Customer, id: "cus_12345") }

  before do
    allow(Rails.logger).to receive(:info)
    allow(Rails.logger).to receive(:error)
    allow(Stripe::Customer).to receive(:create)
  end

  describe "#perform" do
    context "when user is customer" do
      before do
        allow(User).to receive(:find).with(customer.id).and_return(customer)
        allow(Stripe::Customer).to receive(:create).and_return(stripe_customer_double)
        allow(customer).to receive(:update!)
      end

      it "calls Stripe::Customer.create and updates user" do
        worker.perform(customer.id)

        expect(customer).to have_received(:update!).with(stripe_customer_id: stripe_customer_double.id)
      end

      it "logs success message" do
        message = "[StripeService::CreateCustomer] Successfully User ID=#{customer.id}"
        worker.perform(customer.id)

        expect(Rails.logger).to have_received(:info).with(message)
      end
    end

    context "when user is admin" do
      before do
        allow(User).to receive(:find).with(admin.id).and_return(admin)
      end

      it "does not call Stripe::Customer.create" do
        worker.perform(admin.id)

        expect(Stripe::Customer).not_to have_received(:create)
        expect(Rails.logger).not_to have_received(:info)
      end
    end

    context "when Stripe::Customer.create raises error" do
      before do
        allow(Stripe::Customer).to receive(:create).and_raise(StandardError.new("Stripe error"))
        allow(User).to receive(:find).with(customer.id).and_return(customer)
        allow(Rails.logger).to receive(:error)
      end

      it "logs error and raises" do
        error_message = /Failed User ID=#{customer.id}: Stripe error/

        expect do
          worker.perform(customer.id)
        end.to raise_error(StandardError, "Stripe error")

        expect(Rails.logger).to have_received(:error).with(error_message)
      end
    end
  end
end
