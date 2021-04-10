Fabricator(:coupon) do
  code {sequence(:code) {|i| "PASCOA21-#{ '%04d' % i }"}}
  promotion
end
