require 'application_system_test_case'

class CategoriesTest < ApplicationSystemTestCase
  test 'view categories' do
    Category.create!(name: 'Produto Testando', code: 'TESTE')
    Category.create!(name: 'Produto Testando Dois', code: 'TESTE2')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'test123')

    login_as usuario, scope: :user
    visit root_path
    click_on 'Categorias'

    assert_text 'CATEGORIAS'
    assert_text 'Produto Testando'
    assert_text 'TESTE'
    assert_text 'Produto Testando Dois'
    assert_text 'TESTE2'
  end

  test 'create a new category' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'test123')

    login_as usuario, scope: :user
    visit root_path
    click_on 'Categorias'
    click_on 'Nova Categoria'
    fill_in 'Nome', with: 'Cimento'
    fill_in 'Código', with: 'CP-I'
    click_on 'Criar'

    assert_text 'Cimento'
    assert_text 'CP-I'
    assert_current_path categories_path
  end

  test 'edit category' do
    category = Category.create!(name: 'Produto Teste', code: 'TESTE')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'pass123')

    login_as usuario, scope: :user
    visit category_path(category)
    click_on 'Editar Categoria'
    fill_in 'Nome', with: 'Teste editar'
    click_on 'Atualizar Categoria'
    assert_current_path categories_path
    assert_text 'Teste editar'
    assert_no_text 'Produdo Teste'
  end

  test 'delete category' do
    category = Category.create!(name: 'Produto Teste', code: 'TESTE')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'pass123')

    login_as usuario, scope: :user
    visit category_path(category)
    assert_text 'Produto Teste'
    click_on 'Deletar'
    assert_current_path categories_path
    assert_no_text 'Produto Teste'
  end

  test 'dont view category link without login' do
    visit root_path

    assert_no_link 'Categorias'
  end

  test 'dont view categories using route without login' do
    visit categories_path

    assert_current_path new_user_session_path
  end

  test 'dont view categories details without login' do
    categoria_bebidas = Category.create!(name: 'Bebidas', code: 'BEBI')

    visit category_path(categoria_bebidas)

    assert_current_path new_user_session_path
  end

  test 'dont edit categories without login' do
    categoria_bebidas = Category.create!(name: 'Bebidas', code: 'BEBI')

    visit edit_category_path(categoria_bebidas)

    assert_current_path new_user_session_path
  end

  test 'cant create categories without login' do
    visit new_category_path

    assert_current_path new_user_session_path
  end



end
