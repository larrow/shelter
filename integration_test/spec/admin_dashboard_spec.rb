require 'spec_helper'

RSpec.describe "admin dashboard" do
  let(:agent) { Mechanize.new }

  it 'can see dashboard' do
    agent.get('http://proxy/').form_with(id: 'new_user') do |form|
      form['user[login]'] = admin_attrs[:login]
      form['user[password]'] = admin_attrs[:password]
    end.submit

    profile_link = agent.get('/')
      .links
      .select{|link| link.text == 'Profile'}
      .first
    expect(profile_link).to_not be_nil
  end

  it "has no image in a new org" do
    agent.get('http://proxy/').form_with(id: 'new_user') do |form|
      form['user[login]'] = admin_attrs[:login]
      form['user[password]'] = admin_attrs[:password]
    end.submit

    agent.get('http://proxy/n/new').form_with(id: 'new_group') do |form|
      form['group[name]'] = 'testorg'
    end.submit

    image_count = agent.get('http://proxy/testorg').search('.repo-box').length
    expect(image_count).to eq(0)
  end
end

