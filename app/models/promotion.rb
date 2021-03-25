class Promotion < ApplicationRecord
  has_many :coupons

  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: { message: 'não pode ficar em branco'}
  validates :code, :name, uniqueness: { message: 'deve ser único'}


  def generate_coupons!
    return if coupons?
      (1..coupon_quantity).each do |number|  #omite o self.
         coupons.create!(code: "#{code}-#{'%04d' % number}")  #.create vem do has_many e ñ um metodo de array
         #Coupon.create!(code: "#{code}-#{'%04d' % number}", promotion: self)
      end
  end



  def coupons?
    coupons.any?
  end
end
