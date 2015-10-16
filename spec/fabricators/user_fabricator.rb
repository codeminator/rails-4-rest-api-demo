Fabricator(:user) do
  email         { Faker::Internet.email }
  password      { Faker::Lorem.characters(10) }
  role          'user'
end

Fabricator(:guest, from: :user) do
  role           'guest'
end

Fabricator(:admin, from: :user) do
  role           'admin'
end