require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase

  test 'disable a coupon' do
    usuario = Fabricate(:user)
    promotion = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'VERAO-0001', promotion: promotion)

    login_as usuario, scope: :user
    visit promotion_path(promotion)
    click_on 'Desabilitar'

    assert_text "Cupom #{coupon.code} desabilitado com sucesso!"
    assert_text "#{coupon.code}"
    assert_text "(DESABILITADO)"
    assert_no_link 'Desabilitar'
  end

  test 'enable a coupon' do
    usuario = Fabricate(:user)
    promotion = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    login_as usuario, scope: :user
    visit promotion_path(promotion)
    click_on 'Desabilitar'

    assert_text "Cupom #{coupon.code} desabilitado com sucesso!"
    assert_text "#{coupon.code}"
    assert_text "(DESABILITADO)"
    assert_no_link 'Desabilitar'
    click_on 'Habilitar'
    assert_text "Cupom #{coupon.code} habilitado com sucesso!"
    assert_text "#{coupon.code}"
    assert_text "(ATIVO)"
    assert_no_link 'Habilitar'
  end

  test 'search a coupon and finds unique coupon' do
    usuario = Fabricate(:user)
    promo = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'NATAL21-0005', promotion: promo)
    coupon1 = Coupon.create!(code: 'NATAL21-0001', promotion: promo)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    within '.bcupom' do
      fill_in 'Buscar cupom:', with: 'NATAL21-0005'
      click_on 'Buscar'
    end
    assert_text 'NATAL21-0005'
    refute_text 'NATAL21-0001'
    assert_text 'ATIVO'
  end

  test 'search a coupon and finds nothing' do
    usuario = Fabricate(:user)
    promo = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'NATAL21-0005', promotion: promo)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    within '.bcupom' do
      fill_in 'Buscar cupom:', with: 'NATAL21-0003'
      click_on 'Buscar'
    end
    assert_text 'Nenhum cupom encontrado.'
    refute_text 'NATAL21-0005'
  end

  test 'search coupon using route without login' do
    usuario = Fabricate(:user)
    promo = Fabricate(:promotion)
    coupon = Coupon.create!(code: 'NATAL21-0005', promotion: promo)

    visit search_coupons_path(buscar: 'NATAL21-0005')

    assert_text 'Para continuar, efetue login ou registre-se'
    assert_current_path new_user_session_path
  end
end
