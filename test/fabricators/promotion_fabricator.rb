Fabricator(:promotion) do
  name { sequence(:name) {|i| "Verão #{i}"}}
  description 'Promoção de Verão'
  code { sequence(:code) {|i| "VERAO#{i}"}}
  discount_rate 25
  coupon_quantity 10
  expiration_date '09/07/2025'
  user
end
