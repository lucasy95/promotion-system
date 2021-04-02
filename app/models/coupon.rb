class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: {active: 0, disabled: 5}

  def self.buscar(query)
    where('code LIKE :query', query: "#{query}")
  end
end
