require 'web_visitor'
require 'global_vars'
require 'registry'

# this module is designed for user action
module UserSupport
  include WebVisitor
  include GlobalVars

  def sign_up(u)
    new_session!
    user = next_user
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

  def create_group(g)
    group = next_group
    visit('/n/new')
    submit_form(id: 'new_namespace') do |form|
      form['namespace[name]'] = group
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

  def all_images
    as_admin do
      # get all repositoies on multi pages
      urls = visit('/admin/repositories').
        links.
        select{|link| link.text =~ /\d+/ && link.href}.
        map(&:href)
      urls << '/admin/repositories'

      urls.reduce({}) do |sum, url|
        visit(url).css('table tr').map do |row|
          if row.element_children.size >= 2
            image_full_path = row.element_children[0].text.gsub(/[\n ]/, '')
            tags            = row.element_children[1].text.gsub(/[\n ]/, '').split(',')
            sum.update image_full_path => tags
          end
        end
        sum
      end
    end
  end

  def as_admin
    login_as users['管理员'] do
      yield
    end
  end

end
