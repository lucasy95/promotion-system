require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    usuario = Fabricate(:user)
    promotion1 = Fabricate(:promotion)
    promotion2 = Fabricate(:promotion)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    # .strftime('%d/%m/%Y')
    assert_text promotion1.name
    assert_text promotion1.description
    assert_text '25,00%'
    assert_text promotion2.name
    assert_text promotion2.description
    assert_text '25,00%'
  end

  test 'view promotion details' do
    usuario = Fabricate(:user)
    promotion = Fabricate(:promotion)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    assert_text promotion.name
    assert_text promotion.description
    assert_text '25,00%'
    assert_text promotion.code
    assert_text promotion.expiration_date.strftime('%d/%m/%Y')
    assert_text promotion.coupon_quantity
  end

  test 'no promotion are available' do
    usuario = Fabricate(:user)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção encontrada'
  end

  test 'view promotions and return to home page' do
    usuario = Fabricate(:user)
    promo = Fabricate(:promotion)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    assert_text promo.name
    click_on 'Início'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    usuario = Fabricate(:user)
    promo = Fabricate(:promotion)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promo.name
    assert_text promo.coupon_quantity
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    usuario = Fabricate(:user)

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
    usuario = Fabricate(:user)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code/name must be unique' do
    usuario = Fabricate(:user)
    promo = Fabricate(:promotion)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Código', with: promo.code
    fill_in 'Nome', with: promo.name
    click_on 'Criar Promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'generate coupons for a promotion' do
    usuario = Fabricate(:user)
    promotion = Fabricate(:promotion)

    promotion.create_promotion_approval(user: Fabricate(:user))
    login_as usuario, scope: :user
    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_text "#{promotion.code}-0001"
    assert_text "#{promotion.code}-0010"
    assert_no_text "#{promotion.code}-0011"
    assert_no_text "#{promotion.code}-0000"
  end

  test 'edit promotion' do
    usuario = Fabricate(:user)
    promotion = Fabricate(:promotion)

    login_as usuario, scope: :user
    visit promotion_path(promotion)
    click_on 'Editar'
    assert_text 'EDITAR PROMOÇÃO'
    fill_in 'Nome', with: 'Dia dos pais'
    click_on 'Atualizar Promoção'
    assert_text 'Dia dos pais'
    assert_no_text promotion.name
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
    Fabricate(:user)
    promotion = Fabricate(:promotion)

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'create promotion without login -> sign in' do
    visit new_promotion_path
    assert_current_path new_user_session_path
  end

  test 'search promotions by term and finds results' do
    usuario = Fabricate(:user)
    pascoav = Promotion.create!(name: 'Páscoa', description: 'Promoção de Páscoa',
                                code: 'PASC10', discount_rate: 15, coupon_quantity: 100,
                                expiration_date: '04/04/2033', user: usuario)
    promo1 = Fabricate(:promotion)
    promo2 = Fabricate(:promotion)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    within '.bpromocao' do
      fill_in 'Buscar promoção', with: 'Verão'
      click_on 'Buscar'
    end
    assert_text promo1.name
    assert_text promo2.name
    refute_text pascoav.name
  end

  test 'search promotions by term and finds nothing' do
    usuario = Fabricate(:user)
    promo1 = Fabricate(:promotion)
    promo2 = Fabricate(:promotion)
    promo3 = Fabricate(:promotion)

    login_as usuario, scope: :user
    visit root_path
    click_on 'Promoções'
    within '.bpromocao' do
      fill_in 'Buscar promoção', with: 'Dia das crianças'
      click_on 'Buscar'
    end
    assert_text 'Nenhuma promoção encontrada'
    refute_text promo1.name
    refute_text promo2.name
    refute_text promo3.name
  end

  test 'search promotions using route without login' do
    Fabricate(:user)
    Fabricate(:promotion)

    visit search_promotions_path(buscar: 'promo')

    assert_text 'Para continuar, efetue login ou registre-se'
    assert_current_path new_user_session_path
  end

  test 'user approves promotion' do
    usuario2 = Fabricate(:user)
    promo = Fabricate(:promotion)

    login_as usuario2, scope: :user
    approver = usuario2
    visit promotion_path(promo)
    accept_confirm { click_on 'Aprovar' }

    assert_text 'Promoção aprovada com sucesso'
    assert_text "Aprovada por: #{approver.email}"
    assert_link 'Gerar cupons'
    refute_link 'Aprovar'
  end

  test 'apply promotion to category' do
    usuario = Fabricate(:user)
    promo = Fabricate(:promotion)
    categoria = Category.create!(name: 'Produto Testando', code: 'TESTE')

    login_as usuario, scope: :user
    visit promotion_path(promo)
    click_on 'Aplicar promoção'
    check(categoria.name)
    click_on 'Aplicar promoção'
    assert_text categoria.name
    click_on 'Categorias'
    assert_text promo.name
  end

  test 'remove category promotion' do
    usuario = Fabricate(:user)
    promo = Fabricate(:promotion)
    categoria = Category.create!(name: 'Legumes', code: 'LEGU')
    Use.create!(promotion_id: promo.id, category_id: categoria.id)

    login_as usuario, scope: :user
    visit promotion_path(promo)
    assert_text categoria.name
    click_on 'Aplicar promoção'
    click_on 'Aplicar promoção'
    assert_no_text categoria.name
    assert_text 'Nenhuma promoção aplicada'
  end

  test 'apply promotion to categories' do
    usuario = Fabricate(:user)
    promo = Fabricate(:promotion)
    categoria1 = Category.create!(name: 'Cimento', code: 'CPIV')
    categoria2 = Category.create!(name: 'Brita', code: 'BRIT')

    login_as usuario, scope: :user
    visit promotion_path(promo)
    click_on 'Aplicar promoção'
    check(categoria1.name)
    check(categoria2.name)
    click_on 'Aplicar promoção'
    assert_text 'Cimento, Brita'
  end
end
