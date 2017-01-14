require 'web_visitor'
require 'global_vars'
require 'registry'

# this module is designed for user action
module UserSupport
  include WebVisitor
  include GlobalVars

  def sign_up(u)
    new_session!
    user = next_user u
    visit('/users/sign_up')
    submit_form(id: 'new_user') do |form|
      form['user[username]'] = user[:login]
      form['user[email]'] = user[:email]
      form['user[password]'] = user[:password]
      form['user[password_confirmation]'] = user[:password]
    end
    namespaces[u] = user[:login]
    users[u] = user
  end

  # execute block as somebody
  # if u_str is nil, execute as current user
  def do_as u_str
    user = users[u_str.gsub(/用户/, '')]
    if user
      login_as user do
        yield
      end
    else
      yield
    end
  end

  # login operation, and old session will be dismissed.
  # if you want to save current session, you may use block
  def login_as user
    block = -> do
      # web login
      visit('/')
      submit_form(action: '/users/sign_in') do |form|
        form['user[login]'] = user[:login]
        form['user[password]'] = user[:password]
      end
      # registry login
      Registry.login_as user
      store_current_user user
    end

    if block_given?
      new_session do
        old_user = current_user
        block.call
        v = yield
        store_current_user old_user
        v
      end
    else
      new_session!
      block.call
    end
  end

  def create_group(g, publicity=true)
    group = next_group g
    visit('/n/new')
    submit_form(id: 'new_namespace') do |form|
      form['namespace[name]'] = group
      form['namespace[default_publicity]'] = publicity ? '1' : '0'
    end
    groups[g] = group
    namespaces[g] = group
    group
  end

  def add_user_to_group(user, group)
    as_admin do
      visit("/n/#{group}/members/new")
      submit_form(action: "/n/#{group}/members") do |f|
        f['username'] = user[:login]
      end
    end
  end

  def all_tags namespace, image
    as_admin do
      visit('/n/%s/r/%s/tags' % [namespace, image]).css('table tbody tr').map do |row|
        next if row.element_children.size < 2
        row.element_children[0].text.gsub(/[\n ]/, '')
      end
    end
  rescue Mechanize::ResponseCodeError => e
    raise e if e.response_code != '404'
  end

  def as_admin
    login_as users['管理员'] do
      yield
    end
  end



end
