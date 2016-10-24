require 'spec_helper'

RSpec.describe "admin dashboard" do
  let(:agent) { Mechanize.new }

  describe "logged in" do
    before do
      log_in_admin(agent)
    end

    it 'can view dashboard' do
      profile_link = agent.get('/')
        .links
        .select{|link| link.text == 'Profile'}
        .first
      expect(profile_link).to_not be_nil
    end

    it "has no image in a new org" do
      agent.get('http://proxy/n/new').form_with(id: 'new_group') do |form|
        form['group[name]'] = 'testorg'
      end.submit

      image_count = agent.get('http://proxy/testorg').search('.repo-box').length
      expect(image_count).to eq(0)
    end
  end

  describe "not logged in" do
    it "cannot view dashboard" do
      home = agent.get("http://proxy/")
      profile_link = home.links.select{|link| link.text == 'Profile'}.first
      expect(profile_link).to be_nil
    end
  end
end

