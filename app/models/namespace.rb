class Namespace < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :repositories, after_add: :post_to_namespace_channel
  validates :name, presence: true, uniqueness: true
  validates :name, format: /\A[a-zA-Z.0-9_\-]+\z/, length: { in: 2..30 }

  protected

  def post_to_namespace_channel(repository)
    NamespaceChannel.broadcast_to(self, action: 'new_repository', content: ApplicationController.render(repository)) if repository.id # ignore initialize
  end
end
