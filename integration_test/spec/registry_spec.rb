require 'spec_helper'
require 'registry'

ORIGINAL_BLOB1 = File.read('spec/fixtures/blob1')
ORIGINAL_BLOB2 = File.read('spec/fixtures/blob2')
ORIGINAL_DIGEST1 = File.read('spec/fixtures/digest1')
ORIGINAL_DIGEST2 = File.read('spec/fixtures/digest2')
ORIGINAL_MANIFEST_LIBRARY_TEST1 = File.read('spec/fixtures/manifest_library_test1')
ORIGINAL_MANIFEST_TESTORG_TEST1 = File.read('spec/fixtures/manifest_testorg_test1')

RSpec.describe "registry: push/pull an image" do
  let(:agent) { Mechanize.new }

  context "with admin account" do
    let(:registry) { registry_for(admin_attrs) }

    describe "push to library" do
      it "can push" do
        image = "library/testpush"

        digest1 = registry.push_blob(image, ORIGINAL_BLOB1)
        digest2 = registry.push_blob(image, ORIGINAL_BLOB2)
        res = registry.push_manifest(image, 'latest', ORIGINAL_MANIFEST_LIBRARY_TEST1)

        expect(digest1).to eq(ORIGINAL_DIGEST1)
        expect(digest2).to eq(ORIGINAL_DIGEST2)
        expect(res).not_to be_nil
      end
    end

    describe "pullf rom library" do
      let(:image) { "library/testpull" }
      before do
        digest1 = registry.push_blob(image, ORIGINAL_BLOB1)
        digest2 = registry.push_blob(image, ORIGINAL_BLOB2)
        res = registry.push_manifest(image, 'latest', ORIGINAL_MANIFEST_LIBRARY_TEST1)
      end

      it "can pull" do
        blob1 = registry.pull_blob(image, ORIGINAL_DIGEST1)
        blob2 = registry.pull_blob(image, ORIGINAL_DIGEST2)
        manifest = registry.pull_manifest(image, 'latest')

        expect(blob1.bytes).to eq(ORIGINAL_BLOB1.bytes)
        expect(blob2.bytes).to eq(ORIGINAL_BLOB2.bytes)
        expect(manifest).to eq(ORIGINAL_MANIFEST_LIBRARY_TEST1)
      end
    end
  end

  context 'with user account' do
    describe 'not signed up' do
      let(:user_attrs) do
        {
          login: next_username,
          email: next_email,
          password: "testpassword"
        }
      end

      let(:registry) { registry_for(user_attrs) }

      it 'cannot push to group' do
        expect {
          registry.push_blob('testorg/test1', ORIGINAL_BLOB1)
        }.to raise_error(RestClient::Unauthorized)
      end
    end

    describe 'signed up' do
      let(:user_attrs) do
        {
          login: next_username,
          email: next_email,
          password: "testpassword"
        }
      end

      let(:group) { next_group }
      let(:image) { "#{group}/test1" }
      let(:registry) { registry_for(user_attrs) }

      before do
        sign_up(user_attrs)
        create_group(group)
        add_user_to_group(user_attrs, group)
      end

      it 'can push to and pull from group' do
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
end

