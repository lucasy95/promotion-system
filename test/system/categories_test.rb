require 'application_system_test_case'

class CategoriesTest < ApplicationSystemTestCase
  test 'view categories' do
    categoria1 = Fabricate(:category)
    categoria2 = Fabricate(:category)
    usuario = Fabricate(:user)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Categorias'

    assert_text 'CATEGORIAS'
    assert_text categoria1.name
    assert_text categoria1.code
    assert_text categoria2.name
    assert_text categoria2.code
  end

  test 'create a new category' do
    usuario = Fabricate(:user)

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
    category = Fabricate(:category)
    usuario = Fabricate(:user)

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
    category = Fabricate(:category)
    usuario = Fabricate(:user)

    login_as usuario, scope: :user
    visit category_path(category)
    assert_text category.name
    click_on 'Deletar'
    assert_current_path categories_path
    assert_no_text category.name
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
    categoria_bebidas = Fabricate(:category)

    visit category_path(categoria_bebidas)

    assert_current_path new_user_session_path
  end

  test 'dont edit categories without login' do
    categoria_bebidas = Fabricate(:category)

    visit edit_category_path(categoria_bebidas)

    assert_current_path new_user_session_path
  end

  test 'cant create categories without login' do
    visit new_category_path

    assert_current_path new_user_session_path
  end

end
