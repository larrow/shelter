class RepositoryChannel < ApplicationCable::Channel
  def subscribed
    repository = Repository.find_by!(id: params[:id])
    stream_for repository
  end

end
