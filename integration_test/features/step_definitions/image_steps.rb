那么(/^可以在(.*)中添加镜像，版本为(.*)$/) do |label,tag|

  image = "#{namespaces[label]}/test"
  Registry.push image, tag
  expect(all_images[image]).to include(tag)
end

那么(/^不可以在(.*)中添加镜像$/) do |g|
  image = "#{groups[g]}/test"
  Registry.push image, 'v1'
  expect(all_images[image]).to be_nil
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

当(/^用户(.*)在(.*)中添加镜像，版本为(.*)$/) do |u, g, tag_str|
  login_as users[u] do
    image = "#{namespaces[g]}/test"
    tag_str.split(',').map(&:strip).each do |tag|
      Registry.push image, tag
      expect(all_images[image]).to include(tag)
    end
  end
end

当(/^用户(.*)在界面上删除(.*)中镜像的版本(.*)$/) do |u, g, tag|
  login_as users[u] do
    image = "#{namespaces[g]}/test"
    visit "#{image}/tags"
    expect{web_delete "/#{image}/tags/#{tag}"}.not_to raise_error
    expect(all_images[image]).not_to include(tag)
  end
end

那么(/^系统不能获取(.*)中镜像的(.*)版本$/) do |u,v|

  pending # Write code here that turns the phrase above into concrete actions
end

那么(/^用户(.*)能够获取版本(.*)的镜像$/) do |u,v|
  pending # Write code here that turns the phrase above into concrete actions
end

当(/^用户(.*)在界面上删除镜像$/) do |u|
  pending # Write code here that turns the phrase above into concrete actions
end

