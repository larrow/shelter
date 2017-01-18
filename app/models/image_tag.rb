class ImageTag < ApplicationRecord
  include Larrow
  belongs_to :repository

  before_destroy :send_to_registry
  def send_to_registry
    Registry.delete_tag(repository.full_path, self.name)
  end
end
