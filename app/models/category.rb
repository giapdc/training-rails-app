class Category < ApplicationRecord
  scope :search, lambda { |keyword|
    return all if keyword.blank?

    where("name ILIKE :q OR description ILIKE :q", q: "%#{keyword}%")
  }

  validates :name, presence: true, uniqueness: { case_sensitive: false },
                   length: { minimum: 3, maximum: 50 }

  validates :description, presence: true,
                          length: { minimum: 10, maximum: 255 }
end
