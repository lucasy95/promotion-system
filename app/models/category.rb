class Category < ApplicationRecord
  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true
  validates :code, length: { minimum: 4 }
end
