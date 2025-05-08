require "rails_helper"

RSpec.describe OrderItem, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).only_integer }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(1) }
    it { is_expected.to validate_presence_of(:amount_cents) }
    it { is_expected.to validate_numericality_of(:amount_cents).only_integer }
    it { is_expected.to validate_numericality_of(:amount_cents).is_greater_than_or_equal_to(100) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:order_item)).to be_valid
    end
  end
end
