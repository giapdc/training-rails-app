require "rails_helper"

RSpec.describe Order, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:order_items) }
    it { is_expected.to have_many(:products).through(:order_items) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:currency) }
    it { is_expected.to validate_inclusion_of(:currency).in_array(%w[USD JPY]) }
    it { is_expected.to validate_presence_of(:total_amount_cents) }
    it { is_expected.to validate_numericality_of(:total_amount_cents).only_integer }
    it { is_expected.to validate_numericality_of(:total_amount_cents).is_greater_than_or_equal_to(0) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:order)).to be_valid
    end
  end
end
