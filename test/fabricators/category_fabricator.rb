Fabricator(:category) do
  name { sequence(:name) { |i| "Categoria#{i}" } }
  code { sequence(:code) { |i| "CATE#{i}" } }
end
