class User < ApplicationRecord
  attr_accessor :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :authentication_keys => [:login]
  validates :username, format: /\A[a-zA-Z0-9_\.-]*\z/, presence: true, length: { in: 2..30 }, uniqueness: { case_sensitive: false }

  has_one :personal_namespace, class_name: 'Namespace', foreign_key: :creator_id
  has_many :members, dependent: :destroy
  has_many :namespaces, through: :members
  has_many :owned_namespaces, -> { where members: { access_level: :owner }}, through: :members, source: :namespace

  has_many :repositories, through: :namespaces

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

  after_create :ensure_namespace_correct
  def ensure_namespace_correct
    owned_namespaces << create_personal_namespace(name: username)
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

  def groups
    namespaces.where.not name: username
  end

  def personal_repositories
    personal_namespace.repositories
  end

  def create_namespace name
    owned_namespaces.create(name:name, creator: self)
  end
end
