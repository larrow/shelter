require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should create a user namespace when created' do
    user = User.create(username: 'testuser1', email: 'test@example.com', password: 'testtest', password_confirmation: 'testtest')
    assert_not_nil user.personal_namespace
  end

  test 'can create organization' do
    group = users(:user_1).create_namespace('testgroup', true)
    assert users(:user_1).namespaces.include?(group)
    assert group.owners.include?(users(:user_1))

  end
  test 'can create organization repository if the user is a owner of org' do
    group = users(:user_1).create_namespace('testgroup', true)
    repo = group.repositories.new(name: 'testrepo')
    assert users(:user_1).can?(:push, repo)
  end
  test 'can create organization repository if the user is a developer of org' do
    group = users(:user_1).create_namespace('testgroup', true)
    repo = group.repositories.new(name: 'testrepo')
    group.developers << users(:user_2)
    assert users(:user_2).can?(:push, repo)
  end
  test 'can not create organization repository if the user is a viewer of org' do
    group = users(:user_1).create_namespace('testgroup', true)
    repo = group.repositories.new(name: 'testrepo')
    group.viewers << users(:user_2)
    assert_not users(:user_2).can?(:push, repo)
  end
  test 'can not create organization repo if the user is not a collaborator' do
    group = users(:user_1).create_namespace('testgroup', true)
    repo = group.repositories.new(name: 'testrepo')
    assert_not users(:user_2).can?(:update, repo)
  end

  test 'can pull any public repository' do
    group = users(:user_1).create_namespace('testgroup', true)
    repo2 = group.repositories.create(name: 'testrepo')
    repo2.update_attribute(:is_public, true)
    assert users(:user_2).can?(:read, repo2)
  end

  test 'can pull & push any private repository when the user is a developer of group' do
    group = users(:user_1).create_namespace('testgroup', true)
    repo2 = group.repositories.create(name: 'testrepo')
    repo2.update_attribute(:is_public, true)
    assert users(:user_2).can?(:read, repo2)
    assert_not users(:user_2).can?(:push, repo2)
    repo2.update_attribute(:is_public, false)
    assert_not users(:user_2).can?(:read, repo2)
    assert_not users(:user_2).can?(:push, repo2)

    group.developers << users(:user_2)
    assert users(:user_2).can?(:read, repo2)
    assert users(:user_2).can?(:push, repo2)
  end

  test 'can not push to repo when the user is a viewer of group' do
    group = users(:user_1).create_namespace('testgroup', true)
    repo2 = group.repositories.create(name: 'testrepo')
    repo2.update_attribute(:is_public, true)
    assert users(:user_2).can?(:read, repo2)
    assert_not users(:user_2).can?(:push, repo2)
    repo2.update_attribute(:is_public, false)
    assert_not users(:user_2).can?(:read, repo2)
    assert_not users(:user_2).can?(:push, repo2)

    group.viewers << users(:user_2)
    assert users(:user_2).can?(:read, repo2)
    assert_not users(:user_2).can?(:push, repo2)
  end

  test 'can not create repository if the user is not a member of namespace' do
    group = users(:user_1).create_namespace('testgroup', true)
    repo = group.repositories.create(name: 'testrepo')
    assert_not users(:user_2).can?(:create, repo)
    assert_not users(:user_2).can?(:push, repo)
  end
end
