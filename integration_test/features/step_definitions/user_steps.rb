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
  links = find_link label
  expect(links).to_not be_nil
end

假定(/^创建用户(.*)$/) do |u|
  u.split(',').each do |user|
    sign_up(user.strip)
  end
end

假定(/(.*)创建用户组(.*)/) do |u,g|
  do_as u do
    create_group g
  end
end

假定(/用户(.*)加入用户组(.*)/) do |u,g|
  user = users[u]
  group = groups[g]
  add_user_to_group user,group
end

那么(/^显示用户组(.*)$/) do |g|
  link = find_link groups[g]
  expect(link).to_not be_nil
end

当(/^用户(.*)搜索(.*)$/) do |u,s|
  user = users[u]
  visit "/search?utf8=✓&q=#{s}"
end

那么(/^搜索结果包括：用户(.*)的镜像都包含关键字(.*)$/) do |u,k|
  user = users[u]

  user_image_links = page.links.select{|link| link.href =~ /\/n\/#{user}\/r\/[a-zA-Z.0-9_\-]+/ }
  user_image_links.each do |link|
    expect(link.href =~ /\/n\/#{user}\/r\/#{k}/).to_not be_nil
  end

end

并且(/^搜索结果包括：不是用户(.*)的镜像都是公开的镜像，并包含关键字(.*)$/) do |u,k|
  user = users[u]

  result_links = page.links.select{|link| link.href =~ /\/n\/[a-zA-Z.0-9_\-]+\/r\/[a-zA-Z.0-9_\-]+/ }

  other_image_links = result_links.select{|link| !(link.href =~ /\/n\/#{user[:login]}\//) }
  other_image_links.each do |link|
    expect(link.href =~ /\/n\/[a-zA-Z.0-9_\-]+\/r\/#{k}/).to_not be_nil
    expect(link.text =~ /Public/).to_not be_nil
  end
end

当(/^管理员搜索(.*)$/) do |s|
  user = users["管理员"]
  visit "/search?utf8=✓&q=#{s}"
end

那么(/^搜索结果包括：镜像(\d+)个，用户(\d+)个，用户组(\d+)个$/) do |img, u, g|
  image_links = page.links.select{|link| link.href =~ /\/n\/[a-zA-Z.0-9_\-]+\/r\/[a-zA-Z.0-9_\-]+/ }
  expect(image_links.size).to be >= img.to_i

  



end

