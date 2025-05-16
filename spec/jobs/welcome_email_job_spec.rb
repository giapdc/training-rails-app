require "rails_helper"

RSpec.describe WelcomeEmailJob, type: :job do
  let(:user) { create(:user) }

  it "sends welcome email" do
    expect do
      described_class.perform_now(user.id)
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it "sends email to correct user" do
    described_class.perform_now(user.id)
    email = ActionMailer::Base.deliveries.last
    expect(email.to).to include(user.email)
    expect(email.subject).to eq(I18n.t("user_mailer.welcome_email.subject"))
  end
end
