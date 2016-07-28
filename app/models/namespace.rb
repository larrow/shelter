class Namespace < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :repositories
  validates :name, presence: true, uniqueness: true
  validates :name, format: /\A[a-zA-Z.0-9_\-]+\z/, length: { in: 2..30 }
end
