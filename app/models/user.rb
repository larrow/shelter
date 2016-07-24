class User < ApplicationRecord
  attr_accessor :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :authentication_keys => [:login]
  validates_format_of :username, with: /^[a-zA-Z0-9_\.-]*$/, multiline: true

  has_one :namespace
  has_and_belongs_to_many :teams

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  after_save :find_or_create_namespace
  def find_or_create_namespace
    self.namespace ||= Namespace.create(name: self.username, type: :by_user, user: self)
  end
end
