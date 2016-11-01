假定(/^(.*)登录$/) do |u|
  u = u.delete '用户'

  user = (users[u] ||= next_user)
  login_as user
end

当(/^访问(.*)$/) do |page|
  case page
  when '首页'
    visit '/'
  end
end

那么(/^显示(.*)链接$/) do |label|
  links = page
    .links
    .select{|link| link.text.downcase == label.downcase}
  expect(links).to_not be_empty
end

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

假定(/^创建用户(.*)$/) do |u|
  sign_up(u)
end

假定(/^添加一个用户组(.*)$/) do |g|
  create_group g
end

那么(/^显示用户组(.*)$/) do |g|
  links = page
    .links
    .select{|link| link.text.downcase == groups[g].downcase}
  expect(links).to_not be_empty
end

