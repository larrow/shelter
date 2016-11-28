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

    expect(all_images[image]).to include(tag)
    visit tags_url
    expect{web_delete "#{tags_url}/#{tag}"}.not_to raise_error
    # 如果是最后一个标签，删除标签后镜像也将不存在
    if all_images[image]
      expect(all_images[image]).not_to include(tag)
    end
  end
end

当(/^(.*)在界面上删除(.*)中的镜像，成功$/) do |u,g|
  do_as u do
    image = "#{namespaces[g]}/test"
    image_url = "/n/#{namespaces[g]}/r/test"

    expect(all_images[image]).not_to be_empty
    web_delete image_url
    expect(all_images[image]).to be_nil
  end
end

那么(/^系统能够获取(.*)中镜像的(.*)版本$/) do |g, tag|
  image = "#{namespaces[g]}/test"
  expect(all_images[image]).to include(tag)
end

那么(/^系统不能获取(.*)中镜像的(.*)版本$/) do |g, tag|
  image = "#{namespaces[g]}/test"
  if all_images[image]
    expect(all_images[image]).not_to include(tag)
  end
end

那么(/^系统不能获取(.*)中的镜像$/) do |g|
  image = "#{namespaces[g]}/test"
  expect(all_images[image]).to be_nil
end

那么(/^(.*)不能删除分组(.*)$/) do |u, g|
  do_as u do
    group_url = "/n/#{namespaces[g]}"
    web_delete group_url
    expect(find_link namespaces[g]).not_to be_nil
  end
end

那么(/^(.*)删除分组(.*)，成功$/) do |u, g|
  do_as u do
    group_url = "/n/#{namespaces[g]}"
    expect(find_link namespaces[g]).not_to be_nil
    web_delete group_url
    expect(find_link namespaces[g]).to be_nil
  end
end

当(/^系统执行镜像清理任务$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

那么(/^系统释放资源$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

当(/^(.*)将镜像设定为私有$/) do |u|
  pending # Write code here that turns the phrase above into concrete actions
end

那么(/^(.*)不能使用docker命令取得镜像$/) do |u|
  pending # Write code here that turns the phrase above into concrete actions
end

当(/^(.*)将镜像设定为公有$/) do |u|
  pending # Write code here that turns the phrase above into concrete actions
end

那么(/^(.*)能够使用docker命令取得镜像$/) do |u|
  pending # Write code here that turns the phrase above into concrete actions
end

