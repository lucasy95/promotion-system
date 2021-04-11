require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'change password method' do
    usuario = Fabricate(:user)

    oldpass = usuario.password
    usuario.change_pass(123_456)
    assert oldpass != usuario.password
  end
end
