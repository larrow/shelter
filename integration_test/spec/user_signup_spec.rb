require 'spec_helper'

RSpec.describe "user signup" do
  let(:agent) { Mechanize.new }

  it 'can sign up' do
    user = {
      login: next_username,
      email: next_email,
      password: "testpassword"
    }
    agent.get('http://proxy/users/sign_up').form_with(id: 'new_user') do |form|
      form['user[username]'] = user[:login]
      form['user[email]'] = user[:email]
      form['user[password]'] = user[:password]
      form['user[password_confirmation]'] = user[:password]
    end.submit

    profile_link = agent.page.links.select{ |link| link.text == 'Profile' }.first
    expect(profile_link).to_not be_nil
  end

  it 'can be added to group' do
    user = {
      login: next_username,
      email: next_email,
      password: "testpassword"
    }
    sign_up user

    log_in_admin(agent)
    form = agent.get('http://proxy/n/testorg/members/new').forms.last
    form['username'] = user[:login]
    agent.submit(form)

    expect(agent.get('http://proxy/n/testorg/members').body).to include(user[:login])
  end
end
