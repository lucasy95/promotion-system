require "test_helper"

class CouponTest < ActiveSupport::TestCase
  test '.buscar finds nothing' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')
    natalv = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                               code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                               expiration_date: '22/12/2033', user: usuario)
    coupon = Coupon.create!(code: 'NATAL21-0005', promotion: natalv)
    result = Coupon.buscar('NATAL21-0006')

    assert_empty result
  end

  test '.buscar exact coupon' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')
    natal = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                               code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                               expiration_date: '22/12/2033', user: usuario)
    coupon = Coupon.create!(code: 'NATAL21-0002', promotion: natal)
    cupom = Coupon.create!(code: 'NATAL21-0003', promotion: natal)

    result = Coupon.buscar('NATAL21-0002')

    assert_includes result, coupon
    refute_includes result, cupom
  end

end
