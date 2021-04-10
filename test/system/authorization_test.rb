require 'application_system_test_case'

class AuthorizationTest < ApplicationSystemTestCase

  test 'user cant approve own promotion' do
      usuario = Fabricate(:user)
      natal = Fabricate(:promotion, user: usuario)

      login_as usuario, scope: :user
      visit promotion_path(natal)
      
      refute_link 'Aprovar'
  end
end
