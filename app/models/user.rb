class User < ApplicationRecord
  attr_accessor :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :authentication_keys => [:login]
  validates :username, format: /\A[a-zA-Z0-9_\.-]*\z/, presence: true, length: { in: 2..30 }, uniqueness: { case_sensitive: false }

  has_one :namespace

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

  after_create :find_or_create_namespace
  def find_or_create_namespace
    self.namespace ||= Namespace.where(name: self.username).first_or_create { |n| n.user = self }
    self.save
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability
end
