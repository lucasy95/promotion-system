require 'test_helper'

class CategoryFlowTest < ActionDispatch::IntegrationTest
  test 'cant create a category without login' do
    post '/categories', params: { category: { name: 'Cereais', code: 'CERE' } }

    assert_redirected_to new_user_session_path
  end

  test 'cant delete a category without login' do
    categoria = Category.create!(name: 'Comida', code: 'COMI')

    delete category_path(categoria)

    assert_redirected_to new_user_session_path
  end

  test 'cant edit a category without login' do
    Category.create!(name: 'Areia', code: 'SAND')

    patch category_path(Category.last), params: { category: { name: 'Gesso' } }

    assert_redirected_to new_user_session_path
  end
end
