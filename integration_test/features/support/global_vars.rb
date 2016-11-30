require 'account_generator'

# 这里必须使用间接访问，避免全局变量被滥用
# These vars should be used indirectly to avoid being abused
module GlobalVars
  include AccountGenerator

  def users
    $users ||= {'管理员' => admin_attrs}
  end

  def groups
    $groups ||= {}
  end

  def current_user
    $current_user
  end

  def store_current_user user
    $current_user = user
  end

  def namespaces
    $namespaces ||= {'admin' => 'admin', 'library' => 'library'}
  end

end
