require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'testando')

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'pass123')

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'pass123')

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Início'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'pass123')

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar Promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code/name must be unique' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'senha123')

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Código', with: 'NATAL10'
    fill_in 'Nome', with: 'Natal'
    click_on 'Criar Promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'generate coupons for a promotion' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'pass123')

    login_as usuario, scope: :user
    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_text 'NATAL10-0001'
    assert_text 'NATAL10-0050'
    assert_text 'NATAL10-0100'
    assert_no_text 'NATAL10-0000'
    assert_no_text 'NATAL10-0101'

  end

  test 'edit promotion' do
    promotion = Promotion.create!(name: 'Dia das maes', description: 'Promoção de Dia das Mães',
                      code: 'DM2021', discount_rate: 50, coupon_quantity: 30,
                      expiration_date: '01/12/2021')
    usuario = User.create!(email: 'testando@iugu.com.br', password: 'pass123')

    login_as usuario, scope: :user
    visit promotion_path(promotion)
    click_on 'Editar'
    assert_text 'EDITAR PROMOÇÃO'
    fill_in 'Nome', with: 'Dia dos pais'
    click_on 'Atualizar Promoção'
    assert_text 'Dia dos pais'
    assert_no_text 'Dia das maes'
  end

  test 'dont view promotion link without login' do
    visit root_path

    assert_no_link 'Promoções'
  end

  test 'dont view promotions using route without login' do
    visit promotions_path

    assert_current_path new_user_session_path
  end

  test 'view promotion details without login' do
    promotion = Promotion.create!(name: 'Dia das maes', description: 'Promoção de Dia das Mães',
                          code: 'DM2021', discount_rate: 50, coupon_quantity: 30,
                          expiration_date: '01/12/2021')

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'create promotion without login -> sign in' do
    visit new_promotion_path
    assert_current_path new_user_session_path
  end

end
