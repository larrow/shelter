当(/^(.*)在(.*)中添加镜像(.*)，版本为(.*)，成功$/) do |u, g, image, tag_str|
  do_as u do
    image = image.empty? ? 'test' : image
    #分割标签可以是半角或者全角的逗号
    tag_str.split(/[,，]/).map(&:strip).each do |tag|
      Registry.push "#{namespaces[g]}/#{image}", tag
      expect(all_tags namespaces[g], image).to include(tag)
    end
  end
end

那么(/^不可以在(.*)中添加镜像$/) do |g|
  Registry.push "#{groups[g]}/test", 'v1'
  expect(all_tags( groups[g], 'test')).to be_nil
end

当(/^(.*)在界面上删除(.*)中镜像的版本(.*)，成功$/) do |u, g, tag|
  do_as u do
    tags_url = "/n/#{namespaces[g]}/r/test/tags"

    expect(all_tags namespaces[g], 'test').to include(tag)
    visit tags_url
    expect{web_delete "#{tags_url}/#{tag}"}.not_to raise_error
    # 如果是最后一个标签，删除标签后镜像也将不存在
    tags = all_tags namespaces[g], 'test'
    if not tags.nil?
      expect(tags).not_to include(tag)
    end
  end
end

当(/^(.*)在界面上删除(.*)中的镜像，成功$/) do |u,g|
  do_as u do
    image_url = "/n/#{namespaces[g]}/r/test"

    expect(all_tags namespaces[g], 'test').not_to be_empty
    web_delete image_url
    expect(all_tags namespaces[g], 'test').to be_nil
  end
end

那么(/^系统能够获取(.*)中镜像的(.*)版本$/) do |g, tag|
  expect(all_tags namespaces[g], 'test').to include(tag)
end

那么(/^系统不能获取(.*)中镜像的(.*)版本$/) do |g, tag|
  tags = all_tags namespaces[g], 'test'
  if not tags.nil?
    expect(tags).not_to include(tag)
  end
end

那么(/^系统不能获取(.*)中的镜像$/) do |g|
  expect(all_tags namespaces[g], 'test').to be_nil
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

当(/^(.*)访问(.*)中的镜像，变更是否私有的设定$/) do |u, g|
  do_as u do
    repo_url = "/n/#{namespaces[g]}/r/test"
    visit repo_url
    submit_form action: "#{repo_url}/toggle_publicity"
  end
end

那么(/^(.*)不能使用docker命令取得(.*)的镜像$/) do |u, g|
  do_as u do
    expect do
      Registry.pull "#{namespaces[g]}/test", 'v1'
    end.to(
      raise_error(Docker::Error::NotFoundError)
    )
  end
end

那么(/^(.*)能够使用docker命令取得(.*)的镜像$/) do |u, g|
  do_as u do
    Registry.pull "#{namespaces[g]}/test", 'v1'
  end
end

