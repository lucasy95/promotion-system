require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    category = Category.new

    assert_not category.valid?
    assert_includes category.errors[:name], 'não pode ficar em branco'
    assert_includes category.errors[:code], 'não pode ficar em branco'
  end

  test 'name/code must be unique' do
    Category.create!(name: 'Gesso Liso', code: 'GELI')
    category = Category.new(name: 'Gesso Liso', code: 'GELI')

    assert_not category.valid?
    assert_includes category.errors[:code], 'já está em uso'
    assert_includes category.errors[:name], 'já está em uso'
  end
end
