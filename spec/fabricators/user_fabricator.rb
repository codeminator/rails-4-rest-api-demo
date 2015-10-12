Fabricator(:user, aliases: [:guest]) do
  email         { Faker::Internet.email }
  password      { Faker::Lorem.characters(10) }
end

Fabricator(:normal_user, from: :guest) do
  role           'user'
end

Fabricator(:admin_user, from: :user) do
  role           'admin'
end