class Namespace < ApplicationRecord
  self.inheritance_column = nil
  belongs_to :user
  has_many :repositories
  enum type: { by_user: 0, by_group: 1 }
  validates :name, presence: true, uniqueness: true
end
