require 'spec_helper'

ORIGINAL_BLOB1 = File.read('spec/fixtures/blob1')
ORIGINAL_BLOB2 = File.read('spec/fixtures/blob2')
ORIGINAL_DIGEST1 = File.read('spec/fixtures/digest1')
ORIGINAL_DIGEST2 = File.read('spec/fixtures/digest2')
ORIGINAL_MANIFEST_LIBRARY_TEST1 = File.read('spec/fixtures/manifest_library_test1')
ORIGINAL_MANIFEST_TESTORG_TEST1 = File.read('spec/fixtures/manifest_testorg_test1')

RSpec.describe "registry operations" do
  shared_examples 'image maintainer' do
    it 'can push and pull a image' do
      registry = registry_for(user)
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

  describe "admin account" do
    it_should_behave_like 'image maintainer' do
      let(:user) { admin_attrs }
      let(:image) { "library/testimage" }
    end
  end

  describe 'anonymous' do

    let(:registry) { registry_for next_user }

    it 'cannot push to group' do
      expect {
        registry.push_blob('testorg/test1', ORIGINAL_BLOB1)
      }.to raise_error(RestClient::Unauthorized)
    end
  end

  describe 'normal user' do
    let(:user) { next_user }

    before do
      admin_agent = Mechanize.new
      sign_up(user, admin_agent)
    end

    it_should_behave_like 'image maintainer' do
      let(:image) { "#{user[:login]}/test1" }
    end
  end

  describe 'group' do
    let(:user) { next_user }
    let(:group) { next_group }

    before do
      admin_agent = Mechanize.new
      sign_up(user, admin_agent)
      create_group(group, admin_agent)
      add_user_to_group(user, group, admin_agent)
    end

    it_should_behave_like 'image maintainer' do
      let(:image) { "#{group}/test1" }
    end
  end
end

