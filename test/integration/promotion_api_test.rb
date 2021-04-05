require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123', name: 'Teste')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL21',
                                  discount_rate: 50, coupon_quantity: 10, expiration_date: '26/12/2021',
                                  user: usuario)
    coupon = Coupon.create!(code: 'NATAL21-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success  #ou status 200
    assert_equal coupon.code, response.parsed_body['code']
    assert_equal coupon.status, 'active'
  end

  test 'check if the coupon is active' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123', name: 'Teste')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL21',
                                  discount_rate: 50, coupon_quantity: 10, expiration_date: '26/12/2021',
                                  user: usuario)
    coupon = Coupon.create!(code: 'NATAL21-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success  #ou status 200
    assert_equal coupon.code, response.parsed_body['code']
    assert_equal coupon.status, 'active'
  end

end
