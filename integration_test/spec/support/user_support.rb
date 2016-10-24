module UserSupport
  def admin_attrs
    {
      login: "admin",
      password: "shelter12345"
    }
  end

  # Note: next_email/next_username don't generate unique strings,
  # but in practice when running tests it's unlikely to generate duplicated string.
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

  def sign_up(user)
    agent = Mechanize.new
    agent.get('http://proxy/users/sign_up').form_with(id: 'new_user') do |form|
      form['user[username]'] = user[:login]
      form['user[email]'] = user[:email]
      form['user[password]'] = user[:password]
      form['user[password_confirmation]'] = user[:password]
    end.submit
  end

  # The following helpers with params `agent` will use the agent passed in
  # or create a new instance of Mechanize (to avoid double login within one session.
  # Return the agent if the caller wants to use the same session.

  def log_in_admin(agent = nil)
    agent ||= Mechanize.new

    agent.get('http://proxy/').form_with(id: 'new_user') do |form|
      form['user[login]'] = admin_attrs[:login]
      form['user[password]'] = admin_attrs[:password]
    end.submit

    agent
  end

  def create_group(group, agent = nil)
    agent ||= Mechanize.new
    agent = log_in_admin(agent)

    agent.get('http://proxy/n/new').form_with(id: 'new_group') do |form|
      form['group[name]'] = group
    end.submit

    agent
  end

  def add_user_to_group(user, group, agent = nil)
    agent ||= Mechanize.new
    log_in_admin(agent)

    form = agent.get("http://proxy/n/#{group}/members/new").forms.last
    form['username'] = user[:login]
    agent.submit(form)

    agent
  end
end
