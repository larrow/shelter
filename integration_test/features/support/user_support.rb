require 'web_visitor'
require 'global_vars'
require 'registry'

module UserSupport
  include WebVisitor
  include GlobalVars

  def sign_up(u)
    user = next_user
    visit('/users/sign_up').form_with(id: 'new_user') do |form|
      form['user[username]'] = user[:login]
      form['user[email]'] = user[:email]
      form['user[password]'] = user[:password]
      form['user[password_confirmation]'] = user[:password]
    end.submit
    namespaces[u] = user[:login]
    users[u] = user
  end

  # a login operation will dismiss old session
  def login_as user
    new_session!
    # web login
    visit('/').form_with(id: 'new_user') do |form|
      form['user[login]'] = user[:login]
      form['user[password]'] = user[:password]
    end.submit
    # registry login
    Registry.login_as user
    @current_user = user
  rescue
    # Omit login error, happens when admin already logs in.
  end

  def create_group(g)
    group = next_group
    visit('/n/new').form_with(id: 'new_group') do |form|
      form['group[name]'] = group
    end.submit
    groups[g] = group
    namespaces[g] = group
    group
  end

  def add_user_to_group(user, group)
    as_admin do
      visit("/n/#{group}/members/new")
      fill_in 'new_group' do |f|
        f['username'] = user[:login]
      end
    end
  end

  def as_admin
    new_session do
      login_as users['管理员']
      yield
    end
  end

end
