class Site < ApplicationRecord
  belongs_to :account
  has_many :pages
end
