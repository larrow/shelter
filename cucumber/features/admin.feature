Feature: 管理员
  Scenario: 登录
    Given 用户作为管理员登录
    When 访问首页
    Then 显示profile链接

