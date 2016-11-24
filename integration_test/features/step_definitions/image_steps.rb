当(/^(.*)在(.*)中添加镜像，版本为(.*)，成功$/) do |u, g, tag_str|
  do_as u do
    image = "#{namespaces[g]}/test"
    #分割标签可以是半角或者全角的逗号
    tag_str.split(/[,，]/).map(&:strip).each do |tag|
      Registry.push image, tag
      expect(all_images[image]).to include(tag)
    end
  end
end

那么(/^不可以在(.*)中添加镜像$/) do |g|
  image = "#{groups[g]}/test"
  Registry.push image, 'v1'
  expect(all_images[image]).to be_nil
end

当(/^(.*)在界面上删除(.*)中镜像的版本(.*)，成功$/) do |u, g, tag|
  do_as u do
    image = "#{namespaces[g]}/test"
    tags_url = "/n/#{namespaces[g]}/r/test/tags"

    visit tags_url
    expect{web_delete "#{tags_url}/#{tag}"}.not_to raise_error
    # 如果是最后一个标签，删除标签后镜像也将不存在
    if all_images[image]
      expect(all_images[image]).not_to include(tag)
    end
  end
end

当(/^(.*)在界面上删除(.*)中的镜像，成功$/) do |u,g|
  pending # Write code here that turns the phrase above into concrete actions
end

那么(/^系统不能获取(.*)中镜像的(.*)版本$/) do |g, tag|
  pending # Write code here that turns the phrase above into concrete actions
end

那么(/^系统不能获取(.*)中的镜像$/) do |g|
  pending # Write code here that turns the phrase above into concrete actions
end

那么(/^用户(.*)能够获取(.*)中镜像的(.*)版本$/) do |u,g,tag|
  pending # Write code here that turns the phrase above into concrete actions
end

