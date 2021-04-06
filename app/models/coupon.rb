class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: {active: 0, disabled: 5}
  delegate :discount_rate, to: :promotion

  def discount_rate
    promotion.discount_rate
  end

  def self.buscar(query)
    where('code LIKE :query', query: "#{query}")
  end
end
