Fabricator(:activity, aliases: [:activity_normal_user]) do
  name          { configatron.models.activity.available_names.sample }
  distance      { Faker::Number.number(3).to_f.abs }
  venue
  user          { Fabricate(:user) }
end

Fabricator(:activity_admin_user, from: :activity) do
  user          { Fabricate(:user) }
end
