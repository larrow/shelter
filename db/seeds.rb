user_param = {email: 'admin@example.com', username: 'admin', password: 'shelter12345', password_confirmation: 'shelter12345', admin: true}
admin = User.find_by(user_param.slice :email, :username)

if admin.nil?
  admin = User.create user_param
  admin.create_namespace 'library'
end

