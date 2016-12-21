# Note: next_email/next_username don't generate unique strings,
# but in practice when running tests it's unlikely to generate duplicated string.
module AccountGenerator
  def admin_attrs
    {
      login: "admin",
      password: "shelter12345"
    }
  end

  def next_user prefix
    {
      login: "#{prefix}_#{SecureRandom.hex(10)}",
      email: "#{SecureRandom.hex(10)}@example.com",
      password: "testpassword"
    }
  end

  def next_group prefix
    "#{prefix}_#{SecureRandom.hex(10)}"
  end

end
