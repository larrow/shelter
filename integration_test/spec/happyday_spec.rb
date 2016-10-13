require 'spec_helper'
require 'mechanize'
require 'registry'
require 'pry'

ORIGINAL_BLOB1 = File.read('spec/fixtures/blob1')
ORIGINAL_BLOB2 = File.read('spec/fixtures/blob2')
ORIGINAL_DIGEST1 = File.read('spec/fixtures/digest1')
ORIGINAL_DIGEST2 = File.read('spec/fixtures/digest2')
ORIGINAL_MANIFEST_LIBRARY_TEST1 = File.read('spec/fixtures/manifest_library_test1')
ORIGINAL_MANIFEST_TESTORG_TEST1 = File.read('spec/fixtures/manifest_testorg_test1')

RSpec.describe "push/pull a image" do
  before do
    @agent = Mechanize.new
  end

  context "with admin account" do
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

    it "has no image in a new org" do
      @agent.get('http://proxy/').form_with(id: 'new_user') do |form|
        form['user[login]'] = 'admin'
        form['user[password]'] = 'shelter12345'
      end.submit
      @agent.get('http://proxy/n/new').form_with(id: 'new_group') do |form|
        form['group[name]'] = 'testorg'
      end.submit
      image_count = @agent.get('http://proxy/testorg').search('.repo-box').length
      expect(image_count).to eq(0)
    end

    it "can push to library" do
      @agent.get('http://proxy/').form_with(id: 'new_user') do |form|
        form['user[login]'] = 'admin'
        form['user[password]'] = 'shelter12345'
      end.submit

      image = "library/test1"

      registry = Registry.new('http://admin:shelter12345@proxy/')
      digest1 = registry.push_blob(image, ORIGINAL_BLOB1)
      digest2 = registry.push_blob(image, ORIGINAL_BLOB2)
      res = registry.push_manifest(image, 'latest', ORIGINAL_MANIFEST_LIBRARY_TEST1)

      expect(digest1).to eq(ORIGINAL_DIGEST1)
      expect(digest2).to eq(ORIGINAL_DIGEST2)
      expect(res).not_to be_nil
    end

    it "can pull from library" do
      image = 'library/test1'
      registry = Registry.new('http://admin:shelter12345@proxy/')
      blob1 = registry.pull_blob(image, ORIGINAL_DIGEST1)
      blob2 = registry.pull_blob(image, ORIGINAL_DIGEST2)
      manifest = registry.pull_manifest(image, 'latest')

      expect(blob1.bytes).to eq(ORIGINAL_BLOB1.bytes)
      expect(blob2.bytes).to eq(ORIGINAL_BLOB2.bytes)
      expect(manifest).to eq(ORIGINAL_MANIFEST_LIBRARY_TEST1)
    end
  end

  context 'with new account' do

    it 'can sign up' do
      @agent.get('http://proxy/users/sign_up').form_with(id: 'new_user') do |form|
        form['user[username]'] = 'testuser'
        form['user[email]'] = 'example@example.com'
        form['user[password]'] = 'testpassword'
        form['user[password_confirmation]'] = 'testpassword'
      end.submit
      profile_link = @agent.page.links.select{ |link| link.text == 'Profile' }.first
      expect(profile_link).to_not be_nil
    end

    it 'cannot push and pull to testorg' do
      registry = Registry.new('http://testuser:testpassword@proxy/')
      expect{registry.push_blob('testorg/test1', ORIGINAL_BLOB1)}.to raise_error(RestClient::Unauthorized)
    end

    it 'can be added to testorg' do
      @agent.get('http://proxy/').form_with(id: 'new_user') do |form|
        form['user[login]'] = 'admin'
        form['user[password]'] = 'shelter12345'
      end.submit
      form = @agent.get('http://proxy/n/testorg/members/new').forms.last
      form['username'] = 'testuser'
      @agent.submit(form)
      expect(@agent.get('http://proxy/n/testorg/members').body.include?('testuser')).to be(true)
    end

    it 'can push and pull to testorg' do
      registry = Registry.new('http://testuser:testpassword@proxy/')
      image = 'testorg/test1'

      digest1 = registry.push_blob(image, ORIGINAL_BLOB1)
      digest2 = registry.push_blob(image, ORIGINAL_BLOB2)
      res = registry.push_manifest(image, 'latest', ORIGINAL_MANIFEST_TESTORG_TEST1)

      expect(digest1).to eq(ORIGINAL_DIGEST1)
      expect(digest2).to eq(ORIGINAL_DIGEST2)
      expect(res).not_to be_nil

      blob1 = registry.pull_blob(image, ORIGINAL_DIGEST1)
      blob2 = registry.pull_blob(image, ORIGINAL_DIGEST2)
      mani = registry.pull_manifest(image, 'latest')

      expect(blob1.bytes).to eq(ORIGINAL_BLOB1.bytes)
      expect(blob2.bytes).to eq(ORIGINAL_BLOB2.bytes)
      expect(mani).to eq(ORIGINAL_MANIFEST_TESTORG_TEST1)
    end

  end
end

