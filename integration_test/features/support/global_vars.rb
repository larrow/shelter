require 'account_generator'

module GlobalVars
  include AccountGenerator

  def users
    @users ||= {'管理员' => admin_attrs}
  end

  def groups
    @groups ||= {}
  end

  def current_user
    @current_user
  end

  def namespaces
    @namespaces ||= {'admin' => 'admin', 'library' => 'library'}
  end

end
