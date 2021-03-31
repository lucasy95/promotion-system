class Promotion < ApplicationRecord
  has_many :coupons

  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
  validates :code, :name, uniqueness: true


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

  def self.search(query) #self. pois busca em todas as promoções
    where('name LIKE :query OR code LIKE :query OR description LIKE :query', query: "%#{query}%") #LIKE busca por algo parecido antes% depois%
  end
end

# gem kaminari
