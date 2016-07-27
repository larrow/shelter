class Namespace < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :repositories
  validates :name, presence: true, uniqueness: true
end
