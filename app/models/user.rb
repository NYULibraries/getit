class User < ActiveRecord::Base
  VALID_PROVIDERS = %w{ nyu_shibboleth new_school_ldap aleph twitter facebook }
  VALID_INSTITUTION_CODES = Institutions.institutions.keys.map(&:to_s)

  # Available devise modules are:
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :provider, :email, :firstname, :lastname,
    :institution_code, :aleph_id

  # Must have a valid provider
  validates :provider, inclusion: { in: VALID_PROVIDERS }

  # Must have a valid institution code
  validates :institution_code, inclusion: {in: VALID_INSTITUTION_CODES},
    allow_blank: true

  # Resolve the institution based on the institution_code
  def institution
    unless institution_code.blank?
      @institution ||= Institutions.institutions[institution_code.to_sym]
    end
  end
end
