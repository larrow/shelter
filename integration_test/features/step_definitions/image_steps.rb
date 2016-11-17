那么(/^可以在(.*)中添加镜像，版本为(.*)$/) do |label,tag|

  image = "#{namespaces[label]}/test"
  Registry.push image, tag
  expect(all_images).to include(image)
end

那么(/^不可以在(.*)中添加镜像$/) do |g|
  image = "#{groups[g]}/test"
  Registry.push image, 'v1'
  expect(all_images).not_to include(image)
end

那么(/^(.*)可以删除(.*)中前述镜像的(.*)版本$/) do |u, label, tag|
  image = "#{namespaces[label]}/test"
  block = -> do
    visit "#{image}/tags"
    expect{web_delete "/#{image}/tags/#{tag}"}.not_to raise_error
  end
  if u
    login_as(users[u], &block)
  else
    block.call
  end
end
