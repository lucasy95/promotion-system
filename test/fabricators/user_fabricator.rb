Fabricator(:user) do
  email { sequence(:email) { |i| "tester#{i}@iugu.com.br" } }
  password 'pass123'
  name { sequence(:name) { |i| "Tester#{i}" } }
end
