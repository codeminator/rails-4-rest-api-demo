Fabricator(:user) do
  email         { Faker::Internet.email }
  password      { Faker::Lorem.characters(10) }
end

Fabricator(:admin_user, from: :user) do
  role          'admin'
end