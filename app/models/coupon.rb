class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: {active: 0, disabled: 5, usado: 9}
  delegate :discount_rate, to: :promotion #API

  def expiration_date
    promotion.expiration_date.strftime('%d/%m/%Y')
  end

  def promotion_name
    promotion.name
  end

  def self.buscar(query)
    where('code LIKE :query', query: "#{query}")
  end
end
