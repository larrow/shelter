require 'spec_helper'
require 'mechanize'

RSpec.describe "push/pull a image" do
  context "with admin account" do
    before do
      @agent = Mechanize.new
    end

    it 'can see dashboard' do
      @agent.get('http://proxy/').form_with(id: 'new_user') do |form|
        form['user[login]'] = 'admin'
        form['user[password]'] = 'shelter12345'
      end.submit
      profile_link = @agent.get('/')
        .links
        .select{|link| link.text == 'Profile'}
        .first
      expect( profile_link ).to_not be_nil
    end

    it "has no image in registry" do
      # * REST push image
    end

    it "has image in registry" do
      # * add user by api
      # * REST login registry
      # * REST pull image
    end
  end
end

