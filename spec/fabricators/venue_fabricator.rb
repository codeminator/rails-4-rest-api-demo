Fabricator(:venue, aliases: [:venue_normal_user]) do
  name            { Faker::Name.name }
  creator         { Fabricate(:user) }
  latitude        { Faker::Address.latitude }
  longitude       { Faker::Address.longitude }
end

Fabricator(:venue_admin_user, from: :venue) do
  creator         { Fabricate(:admin) }
end
