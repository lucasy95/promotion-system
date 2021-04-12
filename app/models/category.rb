class Category < ApplicationRecord
  has_many :uses, dependent: :destroy
  has_many :promotions, through: :uses

  validates :name, :code, presence: true
  validates :code, uniqueness: true
  validates :code, length: { minimum: 4 }

  def category_filter
    name unless promotions.any?
  end
end
