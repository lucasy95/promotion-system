require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    promotion = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'NATAL21-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success  #ou status 200
    assert_equal coupon.code, response.parsed_body['code']
  end

  test 'check if the coupon is active' do
    promotion = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'NATAL21-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success
    assert_equal coupon.code, response.parsed_body['code']
    assert_equal coupon.status, 'active'
  end

  test 'check coupons index' do
    promotion = Fabricate(:promotion)
    coupons = Coupon.all

    get "/api/v1/coupons"

    promotion.generate_coupons!
    assert_response :success  #ou status 200
    assert_equal coupons.count, promotion.coupon_quantity
  end

  test 'check discount rate' do
    promotion = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'NATAL21-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success  #ou status 200
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion.discount_rate.to_s, body[:discount_rate]
  end

  test 'coupon not found' do
    get "/api/v1/coupons/0"

    assert_response 404
  end

  test 'check if the coupon is used' do
    usuario = Fabricate(:user)
    promotion = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'NATAL21-0001' , promotion: promotion)

    login_as usuario, scope: :user
    post "/api/v1/coupons/#{coupon.code}/usado"

    coupon.reload
    assert_response 200
    assert_equal coupon.status, 'usado'
  end

end
