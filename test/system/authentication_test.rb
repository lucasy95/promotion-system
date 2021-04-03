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
    within ".actions" do
      click_on 'Entrar'
    end

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

  test 'empty input field - sign up' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: ''
    fill_in 'Senha', with: ''
    fill_in 'Confirmação de senha', with: ''
    click_on 'Finalizar Cadastro'

    assert_text 'Email não pode ficar em branco'
    assert_text 'Senha não pode ficar em branco'
    assert_current_path user_registration_path
  end

  test 'min password length' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: 'testando@iugu.com.br'
    fill_in 'Senha', with: '1'
    fill_in 'Confirmação de senha', with: '1'
    click_on 'Finalizar Cadastro'

    assert_text 'Senha é muito curto (mínimo: 6 caracteres)'
  end

  test 'max password length' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: 'testando@iugu.com.br'
    fill_in 'Senha', with: '12345678901234567890'
    fill_in 'Confirmação de senha', with: '12345678901234567890'
    click_on 'Finalizar Cadastro'

    assert_text 'Senha é muito longa (máximo: 15 caracteres)'
  end

  test 'email already in use' do
    usuario = User.create!(email: 'usuario01@iugu.com.br', password: 'pass123')

    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: usuario.email
    fill_in 'Senha', with: usuario.password
    fill_in 'Confirmação de senha', with: usuario.password
    click_on 'Finalizar Cadastro'

    assert_text 'Email já está em uso'
  end

  test 'confirm password' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: 'testando@iugu.com.br'
    fill_in 'Senha', with: 'pass123'
    fill_in 'Confirmação de senha', with: 'pass345'
    click_on 'Finalizar Cadastro'

    assert_text 'Confirmação de senha não é igual a Senha'
  end

  test 'wrong password' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: 'test@iugu.com.br'
    fill_in 'Senha', with: '123456'
    within ".actions" do
      click_on 'Entrar'
    end

    assert_text 'Email ou senha inválida'
  end

  test 'change password' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: 'testando@iugu.com.br'
    fill_in 'Senha', with: 'senha123'
    within ".actions" do
      click_on 'Entrar'
    end
    click_on 'Trocar senha'
    fill_in 'Nova senha', with: 'senha678'
    fill_in 'Confirmação de senha', with: 'senha678'
    fill_in 'Senha atual', with: usuario.password
    within ".actions" do
      click_on 'Trocar senha'
    end
    assert_text 'Sua senha foi trocada com sucesso'
    assert_current_path root_path
  end

  test 'change password error' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')

    usuario.change_pass(123456)

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: 'testando@iugu.com.br'
    fill_in 'Senha', with: 'senha123'
    within ".actions" do
      click_on 'Entrar'
    end
    assert_text 'Email ou senha inválida'
  end

  # TODO: Usuario.name
end
