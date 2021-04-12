Fabricator(:coupon) do
  code { sequence(:code) { |i| "PASCOA21-#{format('%04d', i)}" } }
  promotion
end
