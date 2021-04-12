require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest
  test 'can create a promotion' do   # testar um controller
    usuario = Fabricate(:user)
    login_as usuario, scope: :user

    post '/promotions', params: { promotion: { name: 'Natal',
                                               description: 'Promoção de Natal', code: 'NATAL21',
                                               discount_rate: 50, coupon_quantity: 10, expiration_date: '26/12/2021' } }

    assert_redirected_to promotion_path(Promotion.last)
    # assert_response :found  #status encontrado/ñ chega na view
    follow_redirect!
    assert_response :success
    assert_select 'td', 'Natal'
  end

  test 'cant create a promotion without login' do # testar um controller
    post '/promotions', params: { promotion: { name: 'Natal',
                                               description: 'Promoção de Natal',
                                               code: 'NATAL21',
                                               discount_rate: 50,
                                               coupon_quantity: 10,
                                               expiration_date: '26/12/2021' } }

    assert_redirected_to new_user_session_path
  end

  test 'cant generate coupons without login' do
    Fabricate(:user)
    promotion = Fabricate(:promotion)

    # post "/promotions/#{promotion.id}/generate_coupons"  ou
    post generate_coupons_promotion_path(promotion)

    assert_redirected_to new_user_session_path
  end

  test 'cant delete a promotion without login' do
    Fabricate(:user)
    promocao = Fabricate(:promotion)

    delete promotion_path(promocao)

    assert_redirected_to new_user_session_path
  end

  test 'cant edit a promotion without login' do
    Fabricate(:user)
    Fabricate(:promotion)

    patch promotion_path(Promotion.last), params: { promotion: { name: 'Pascoa' } }

    assert_redirected_to new_user_session_path
  end

  test 'cant approve if Im owner' do
    usuario = Fabricate(:user)
    promocao = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                 code: 'NATAL21', discount_rate: 50,
                                 coupon_quantity: 10, expiration_date: '26/12/2021',
                                 user: usuario)

    login_as usuario, scope: :user
    post approve_promotion_path(promocao)
    assert_redirected_to promotion_path(promocao)
    assert_not promocao.reload.approved? # reload, atualizar com o db
    assert_equal 'Ação não permitida', flash[:alert]
  end

  # test 'cant approve a promotion without login' do
  # usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')
  # promocao = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL21',
  #   discount_rate: 50, coupon_quantity: 10, expiration_date: '26/12/2021',
  #   user: usuario)

  # post approve_promotion_path(promocao)
  # assert_redirected_to new_user_session_path
  # end
end
