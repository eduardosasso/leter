class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :user_account
  has_one :account, through: :user_account
  has_many :sites, through: :account

  # after_commit :create_default_account, on: :create

  def create_default_account
    User.transaction do
      account = Account.create(name: email, paid: false)
      UserAccount.create(user: self, account: account)
    end
  end

  def default_site
    sites.first
  end
end
