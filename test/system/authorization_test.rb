require 'application_system_test_case'

class AuthorizationTest < ApplicationSystemTestCase

  test 'user cant approve own promotion' do
      usuario = User.create!(email: 'outrousuario@iugu.com.br', password: 'pass789')
      natal = Promotion.create!(name: 'Natal 2021', description: 'Promoção de Natal 21',
                                code: 'NATAL21', discount_rate: 10, coupon_quantity: 100,
                                expiration_date: '25/12/2021', user: usuario)

      login_as usuario, scope: :user
      visit promotion_path(natal)

      refute_link 'Aprovar'
  end
end
