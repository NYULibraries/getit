class User < ActiveRecord::Base
  VALID_PROVIDERS = %w{ nyu_shibboleth new_school_ldap aleph twitter facebook }

  # Available devise modules are:
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :provider, :email, :firstname, :lastname,

  # Must have a valid provider
  validates :provider, inclusion: { in: VALID_PROVIDERS }

end
