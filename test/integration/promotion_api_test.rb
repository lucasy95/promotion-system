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

  test 'check coupons index' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123', name: 'Teste')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL21',
                                  discount_rate: 50, coupon_quantity: 10, expiration_date: '26/12/2021',
                                  user: usuario)
    coupons = Coupon.all

    get "/api/v1/coupons"

    promotion.generate_coupons!
    assert_response :success  #ou status 200
    assert_equal coupons.count, promotion.coupon_quantity
  end

  test 'check discount rate' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123', name: 'Teste')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL21',
                                  discount_rate: 50, coupon_quantity: 10, expiration_date: '26/12/2021',
                                  user: usuario)
    coupon = Coupon.create!(code: 'NATAL21-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response :success  #ou status 200
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion.discount_rate.to_s, body[:discount_rate]
  end

  test 'coupon not found' do
    get "/api/v1/coupons/0", as: :json

    assert_response 404
  end

end
