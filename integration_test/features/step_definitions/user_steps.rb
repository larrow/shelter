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

