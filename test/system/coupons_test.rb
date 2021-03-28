require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase

  test 'disable a coupon' do
    promotion = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 1,
                          description: 'Promoção de Cyber Monday',
                          code: 'CYBER15', discount_rate: 15,
                          expiration_date: '22/12/2033')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'pass123')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    #promotion.generate_coupons!

    login_as usuario, scope: :user 
    visit promotion_path(promotion)
    click_on 'Desabilitar'

    assert_text "Cupom #{coupon.code} desabilitado com sucesso!"
    assert_text "#{coupon.code}"
    assert_text "(DESABILITADO)"
    assert_no_link 'Desabilitar'
  end
end
