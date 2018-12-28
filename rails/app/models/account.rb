class Account < ApplicationRecord
  has_many :user_accounts
  has_many :users, through: :user_accounts
  has_many :sites

  validates :name, presence: true, uniqueness: true
end
