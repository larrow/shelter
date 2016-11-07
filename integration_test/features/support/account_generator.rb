# Note: next_email/next_username don't generate unique strings,
# but in practice when running tests it's unlikely to generate duplicated string.
module AccountGenerator
  def admin_attrs
    {
      login: "admin",
      password: "shelter12345"
    }
  end

  def next_user
    {
      login: next_username,
      email: next_email,
      password: "testpassword"
    }
  end
  def next_email
    id = SecureRandom.hex(10)
    "#{id}@example.com"
  end

  def next_username
    id = SecureRandom.hex(10)
    "user_#{id}"
  end

  def next_group
    id = SecureRandom.hex(10)
    "group_#{id}"
  end


end
