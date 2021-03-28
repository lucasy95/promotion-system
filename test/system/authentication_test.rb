require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'sign up' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: 'testando@iugu.com.br'
    fill_in 'Senha', with: 'test123'
    fill_in 'Confirmação de senha', with: 'test123'
    click_on 'Finalizar Cadastro'

    assert_text 'Usuário cadastrado com sucesso'
    assert_text 'testando@iugu.com.br'
    assert_link 'Sair'
    assert_no_link 'Cadastrar'
    assert_current_path root_path
  end

  test 'sign in' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: usuario.email
    fill_in 'Senha', with: usuario.password
    click_on 'Log in'

    assert_text 'Login efetuado com sucesso!'
    assert_text usuario.email
    assert_current_path root_path
    assert_link 'Sair'
    assert_no_link 'Entrar'
    assert_no_link 'Cadastrar'
  end

  test 'logout' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'pass123')

    login_as usuario, scope: :user

    visit root_path
    assert_no_link 'Cadastrar'
    assert_no_link 'Entrar'
    assert_link 'Promoções'
    click_on 'Sair'
    assert_text 'Você saiu da sua conta.'
  end

  # TODO: erros no cadastrar
  # TODO: erro ao logar
  # TOOD: Usuario.name

end
