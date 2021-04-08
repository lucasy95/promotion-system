class Promotion < ApplicationRecord
  belongs_to :user

  has_many :coupons

  has_many :uses
  has_many :categories, through: :uses

  has_one :promotion_approval  #só tem um aprovar
  has_one :approver, through: :promotion_approval, source: :user

  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
  validates :code, :name, uniqueness: true

  def generate_coupons!
    return if coupons?
      (1..coupon_quantity).each do |number|  #omite o self.
         coupons.create!(code: "#{code}-#{'%04d' % number}")
         #Coupon.create!(code: "#{code}-#{'%04d' % number}", promotion: self)
      end
  end

  def coupons?
    coupons.any?
  end

  def self.search(query)
    where('name LIKE :query OR code LIKE :query OR description LIKE :query', query: "%#{query}%")
  end

  def approved?
    promotion_approval.present?
  end

  def can_approve?(current_user)
    user != current_user
  end

end
# gem kaminari
