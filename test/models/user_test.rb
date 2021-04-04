require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'change password method' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123', name: 'Teste')

    oldpass = usuario.password
    usuario.change_pass(123456)
    assert oldpass != usuario.password
  end
end
