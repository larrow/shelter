那么(/^可以在(.*)中添加镜像$/) do |label|

  image = "#{namespaces[label]}/test1"
  registry = registry_for(current_user)
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

那么(/^可以删除(.*)中的镜像$/) do |label|
  _image = "#{namespaces[label]}/test1"
  pending
end
