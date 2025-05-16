require "rails_helper"

RSpec.describe Category, type: :model do
  describe "validations" do
    subject { build(:category) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_presence_of(:description) }

    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(50) }

    it { is_expected.to validate_length_of(:description).is_at_least(10).is_at_most(255) }
  end

  describe ".search" do
    let!(:first_category) { create(:category, name: "Ruby", description: "Ruby language") }
    let!(:second_category) { create(:category, name: "Rails", description: "Rails framework") }
    let!(:thirst_category) { create(:category, name: "JavaScript", description: "Frontend language") }

    context "when keyword is blank" do
      it "returns all categories" do
        expect(described_class.search(nil)).to contain_exactly(first_category, second_category, thirst_category)
        expect(described_class.search("")).to contain_exactly(first_category, second_category, thirst_category)
      end
    end

    context "when keyword is present" do
      it "returns categories matching name" do
        expect(described_class.search("ruby")).to include(first_category)
        expect(described_class.search("ruby")).not_to include(second_category, thirst_category)
      end

      it "returns categories matching description" do
        expect(described_class.search("framework")).to include(second_category)
        expect(described_class.search("framework")).not_to include(first_category, thirst_category)
      end

      it "is case insensitive" do
        expect(described_class.search("RUBY")).to include(first_category)
      end

      it "returns empty if no match" do
        expect(described_class.search("python")).to be_empty
      end
    end
  end
end
