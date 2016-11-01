module UserSupport
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


  # The following helpers need params `agent`, which is a Mechanize instance.

  def sign_up(user, agent)
    agent.get('http://proxy/users/sign_up').form_with(id: 'new_user') do |form|
      form['user[username]'] = user[:login]
      form['user[email]'] = user[:email]
      form['user[password]'] = user[:password]
      form['user[password_confirmation]'] = user[:password]
    end.submit
  end

  def login_as user_type
    user = if user_type == :admin
             admin_attrs
           else
             next_user
           end
    agent.get('http://proxy/').form_with(id: 'new_user') do |form|
      form['user[login]'] = user[:login]
      form['user[password]'] = user[:password]
    end.submit
  rescue
    # Omit login error, happens when admin already logs in.
  end

  def create_group(group)
    agent.get('http://proxy/n/new').form_with(id: 'new_group') do |form|
      form['group[name]'] = group
    end.submit
  end

  def add_user_to_group(user, group)
    as_admin do
      form = agent.get("http://proxy/n/#{group}/members/new").forms.last
      form['username'] = user[:login]
      agent.submit(form)
    end
  end

  def as_admin
    current_agent = @agent
    @agent = Mechanize.new
    login_as :admin
    yield
    @agent = current_agent
  end

  def agent
    @agent ||= Mechanize.new
  end

  def page
    @page
  end

  def visit url
    @page = agent.get url
  end
end
