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
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    promotion = Promotion.new(code: 'NATAL10')

    refute promotion.valid?
    assert_includes promotion.errors[:code], 'já está em uso'

  end

  test 'name must be uniq' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    promotion = Promotion.new(name: 'Natal')

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'já está em uso'

  end

  test 'generate_coupons! successfully' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    promotion.generate_coupons!
    assert promotion.coupons.size == promotion.coupon_quantity
    assert promotion.coupons.first.code == 'NATAL10-0001'
  end

  test 'generate_coupons! cannot be called twice' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Coupon.create!(code: 'TEST123', promotion: promotion)
    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test '.search exact promotion' do  #(.) método de classe convenção
    natalv = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    pascoav = Promotion.create!(name: 'Páscoa', description: 'Promoção de Páscoa',
                                        code: 'PASC10', discount_rate: 15, coupon_quantity: 100,
                                        expiration_date: '04/04/2033')

    result = Promotion.search('Natal')

    assert_includes result, natalv
    refute_includes result, pascoav
  end

  test '.search by partial' do
    natal = Promotion.create!(name: 'Natal 2021', description: 'Promoção de Natal 21',
                                      code: 'NATAL21', discount_rate: 10, coupon_quantity: 100,
                                      expiration_date: '25/12/2021')
    pascoav = Promotion.create!(name: 'Páscoa', description: 'Promoção de Páscoa',
                                       code: 'PASC10', discount_rate: 15, coupon_quantity: 100,
                                       expiration_date: '04/04/2033')
    natal22 = Promotion.create!(name: 'Natal 2022', description: 'Promoção de Natal 22',
                                       code: 'NATAL22', discount_rate: 15, coupon_quantity: 100,
                                       expiration_date: '25/12/2022')

    result = Promotion.search('Natal')

    assert_includes result, natal
    assert_includes result, natal22
    refute_includes result, pascoav
  end

  test '.search finds nothing' do
    natalv = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    pascoav = Promotion.create!(name: 'Páscoa', description: 'Promoção de Páscoa',
                                        code: 'PASC10', discount_rate: 15, coupon_quantity: 100,
                                        expiration_date: '04/04/2033')

    result = Promotion.search('Aniversario')

    assert_empty result
  end
end
