module NamespacesHelper
  def can_update? namespace
    if namespace.owner
      namespace.owner == current_user
    else
      can?(:update, namespace)
    end
  end
end
