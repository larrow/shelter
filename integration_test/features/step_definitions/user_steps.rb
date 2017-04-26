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

当(/^以(.*)为关键字执行搜索$/) do |s|
  visit "/search?utf8=✓&q=#{s}"
end


那么(/^搜索结果包括镜像(.*)$/) do |img_str|
  img_str.split(',').each do |img|
    expect( search_result[:images] ).to include(img)
  end
end

那么(/^搜索结果不包括镜像(.*)$/) do |img_str|
  img_str.split(',').each do |img|
    expect( search_result[:images] ).to_not include(img)
  end
end


那么(/^搜索结果包括用户组(.*)$/) do |group_str|
  group_str.split(',').each do |group|
    expect( search_result[:groups] ).to include(namespaces[group])
  end
end

当(/^设定(.*)用户自注册$/) do |permission|
  as_admin do
    visit '/admin/setting/edit'
    submit_form(action: '/admin/setting') do |form|
      if permission == '禁止'
        form.checkbox_with(name: "self_registration").uncheck
      elsif permission == '允许'
        form.checkbox_with(name: "self_registration").check
      end
    end
  end
end

那么(/^用户访问注册页面$/) do
  new_session!
  agent.redirect_ok = false
  visit '/users/sign_up'
end

而且(/^页面被重定向$/) do
  expect(page.code).to eq('302')
end

而且(/^页面未被重定向$/) do
  expect(page.code).not_to eq('302')
end
