class NamespaceChannel < ApplicationCable::Channel
  def subscribed
    namespace = Namespace.find_by!(name: params[:namespace])
    stream_for namespace
  end
end
