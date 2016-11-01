Given(/^用户作为(.*)登录$/) do |user|
  login_as(user=="管理员" ? :admin : :normal)
end

When(/^访问(.*)$/) do |page|
  case page
  when '首页'
    visit '/'
  end
end

Then(/^显示(.*)链接$/) do |label|
  links = page
    .links
    .select{|link| link.text.downcase == label.downcase}
  expect(links).to_not be_empty
end
