require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should create a user namespace when created' do
    user = User.create(username: 'testuser1', email: 'test@example.com', password: 'testtest', password_confirmation: 'testtest')
    assert_not_nil user.namespace
    assert user.namespace.name == user.username
  end

  test 'can create personal repository' do
    repo = users(:user_1).create_personal_repository('testrepo')
    assert_equal users(:user_1), repo.owner
  end

  test 'can create organization' do
    group = users(:user_1).create_group('testgroup')
    assert users(:user_1).authorized_groups.include?(group)
    assert group.owners.include?(users(:user_1))

  end
  test 'can create organization repository if the user is a owner of org' do
    group = users(:user_1).create_group('testgroup')
    repo = group.repositories.new(name: 'testrepo')
    assert users(:user_1).can?(:push, repo)
  end
  test 'can create organization repository if the user is a member of org' do
    group = users(:user_1).create_group('testgroup')
    repo = group.repositories.new(name: 'testrepo')
    group.add_user(users(:user_2), :member)
    assert users(:user_2).can?(:push, repo)
  end
  test 'can not create organization repo if the user is not a collaborator' do
    group = users(:user_1).create_group('testgroup')
    repo = group.repositories.new(name: 'testrepo')
    assert_not users(:user_2).can?(:update, repo)
  end

  test 'can pull any public repository' do
    repo1 = users(:user_1).create_personal_repository('testrepo')
    repo1.update_attribute(:is_public, true)
    assert users(:user_2).can?(:read, repo1)
    group = users(:user_1).create_group('testgroup')
    repo2 = group.repositories.create(name: 'testrepo')
    repo2.update_attribute(:is_public, true)
    assert users(:user_2).can?(:read, repo2)
  end

  test 'can pull & push any private repository when the user is a collaborator' do
    repo1 = users(:user_1).create_personal_repository('testrepo')
    repo1.update_attribute(:is_public, true)
    assert users(:user_2).can?(:read, repo1)
    assert_not users(:user_2).can?(:push, repo1)
    repo1.update_attribute(:is_public, false)
    assert_not users(:user_2).can?(:read, repo1)
    assert_not users(:user_2).can?(:push, repo1)

    repo1.add_user(users(:user_2), :member)

    assert users(:user_2).can?(:read, repo1)
    assert users(:user_2).can?(:push, repo1)

    group = users(:user_1).create_group('testgroup')
    repo2 = group.repositories.create(name: 'testrepo')
    repo2.update_attribute(:is_public, true)
    assert users(:user_2).can?(:read, repo2)
    assert_not users(:user_2).can?(:push, repo2)
    repo2.update_attribute(:is_public, false)
    assert_not users(:user_2).can?(:read, repo2)
    assert_not users(:user_2).can?(:push, repo2)

    group.add_user(users(:user_2), :member)
    assert users(:user_2).can?(:read, repo2)
    assert users(:user_2).can?(:push, repo2)
  end

  test 'can change repository\'s collaborators when the user is a owner' do
    group = users(:user_1).create_group('testgroup')
    repo = group.repositories.create(name: 'testrepo')
    assert users(:user_1).can?(:update, repo)
  end

  test 'can not change collaborators when the user is not a owner' do
    group = users(:user_1).create_group('testgroup')
    repo = group.repositories.create(name: 'testrepo')
    assert_not users(:user_2).can?(:update, repo)
    repo.add_user(users(:user_2), :member)
    assert_not users(:user_2).can?(:update, repo)
  end

  test 'can not create repository if the user is not a member of namespace' do
    group = users(:user_1).create_group('testgroup')
    repo = group.repositories.create(name: 'testrepo')
    assert_not users(:user_2).can?(:create, repo)
    assert_not users(:user_2).can?(:push, repo)
  end
end
