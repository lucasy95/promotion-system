require "test_helper"

class CouponTest < ActiveSupport::TestCase
  test '.buscar finds nothing' do
    usuario = Fabricate(:user)
    natalv = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'NATAL21-0005', promotion: natalv)
    result = Coupon.buscar('NATAL21-0006')

    assert_empty result
  end

  test '.buscar exact coupon' do
    usuario = Fabricate(:user)
    natal = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'NATAL21-0002', promotion: natal)
    cupom = Coupon.create!(code: 'NATAL21-0003', promotion: natal)

    result = Coupon.buscar('NATAL21-0002')

    assert_includes result, coupon
    refute_includes result, cupom
  end

end
