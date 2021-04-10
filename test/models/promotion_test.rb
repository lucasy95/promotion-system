require 'test_helper'

class PromotionTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    promotion = Promotion.new

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em '\
                                                      'branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em'\
                                                        ' branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em'\
                                                        ' branco'
  end

  test 'code must be uniq' do
    usuario = Fabricate(:user)
    promo1 = Fabricate(:promotion)
    promotion = Promotion.new(code: promo1.code)

    refute promotion.valid?
    assert_includes promotion.errors[:code], 'já está em uso'
  end

  test 'name must be uniq' do
    usuario = Fabricate(:user)
    promo1 = Fabricate(:promotion)
    promotion = Promotion.new(name: promo1.name)

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'já está em uso'
  end

  test 'generate_coupons! successfully' do
    usuario = Fabricate(:user)
    promotion = Fabricate(:promotion)

    promotion.generate_coupons!
    assert promotion.coupons.size == promotion.coupon_quantity
    assert promotion.coupons.first.code == "#{promotion.code}-0001"
  end

  test 'generate_coupons! cannot be called twice' do
    usuario = Fabricate(:user)
    promotion = Fabricate(:promotion)
    Coupon.create!(code: 'TEST123', promotion: promotion)

    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test '.search exact promotion' do
    promo1 = Fabricate(:promotion, name: 'Inverno',
                        description: 'Promoção de Inverno')
    promo2 = Fabricate(:promotion)

    result = Promotion.search('Inverno')

    assert_includes result, promo1
    refute_includes result, promo2
  end

  test '.search by partial' do
    natal21 = Fabricate(:promotion, name: 'Natal 21')
    pascoa = Fabricate(:promotion, name: 'Páscoa',
                        description: 'Promoção de Páscoa')
    natal22 = Fabricate(:promotion, name: 'Natal 22')

    result = Promotion.search('Natal')

    assert_includes result, natal21
    assert_includes result, natal22
    refute_includes result, pascoa
  end

  test '.search finds nothing' do
    promo1 = Fabricate(:promotion, name: 'Natal')
    promo2 = Fabricate(:promotion, name: 'Páscoa')

    result = Promotion.search('Aniversário')

    assert_empty result
  end
end
