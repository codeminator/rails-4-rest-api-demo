#--------------Create the default User---------------------
admin_user = User.find_or_initialize_by email: ENV['ADMIN_USER_EMAIL']
admin_user.password, admin_user.password_confirmation = [ENV['ADMIN_USER_PASSWORD'], ENV['ADMIN_USER_PASSWORD']]
admin_user.role = :admin
admin_user.save(validate: false)

normal_user = User.find_or_initialize_by email: ENV['NORMAL_USER_EMAIL']
normal_user.password, normal_user.password_confirmation = [ENV['NORMAL_USER_PASSWORD'], ENV['NORMAL_USER_PASSWORD']]
normal_user.role = :user
normal_user.save(validate: false)

guest_user = User.find_or_initialize_by email: ENV['GUEST_USER_EMAIL']
guest_user.password, guest_user.password_confirmation = [ENV['GUEST_USER_PASSWORD'], ENV['GUEST_USER_PASSWORD']]
guest_user.save(validate: false)


puts "****************************************************************************************************"
puts "****************************************************************************************************"
puts "----------To consume the API, you must add the following headers to the request"
puts "----------Accept => application/vnd.#{ENV['API_VENDOR']}+json;version=#{ENV['API_DEFUALT_VERSION']}"
{
  'admin' => admin_user,
  'user' => normal_user,
  'guest' => guest_user
}.each do |identifier, usr_object|
  puts "-------For #{identifier.humanize} :"
  puts "----------#{ENV['EMAIL_HEADER']} => #{usr_object.email}"
  puts "----------#{ENV['AUTHENTICATION_TOKEN_HEADER']} => #{usr_object.authentication_token}"
  puts ""
end

puts "****************************************************************************************************"
puts "****************************************************************************************************"
