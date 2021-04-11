class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :promotions
  has_many :promotion_approvals
  has_many :approved_promotions, through: :promotion_approvals, source: :promotion

  validates :name, presence: true

  def change_pass(new_pass)
    self.password = new_pass
    save
  end
end
