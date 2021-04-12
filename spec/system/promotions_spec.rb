require 'rails_helper'

describe 'Promotions System Test' do


  it 'view promotions' do
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
end
