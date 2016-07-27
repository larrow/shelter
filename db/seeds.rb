admin = User.create(email: 'admin@example.com', username: 'admin', password: 'shelter12345', password_confirmation: 'shelter12345', admin: true)
library_group = Group.create(name: 'library')
library_group.add_user(admin, :owner)
