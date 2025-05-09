class User < ApplicationRecord
  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy

  enumerize :role, in: { admin: "admin", staff: "staff", customers: "customers" }, default: :customers,
                   predicates: true, scope: true
  enumerize :gender, in: { male: "male", female: "female", other: "other" }, default: :other, predicates: true,
                     scope: true

  validates :name, presence: true
  validates :birthday, presence: true
  validates :gender, presence: true
  validates :address, allow_nil: true, length: { minimum: 20 }
  validates :role, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
