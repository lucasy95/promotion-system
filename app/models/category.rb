class Category < ApplicationRecord
  has_many :uses
  has_many :promotions, through: :uses

  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true
  validates :code, length: { minimum: 4 }

  def category_filter
    unless promotions.any?
      name
    else
    end
  end

end
