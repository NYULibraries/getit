class User < ActiveRecord::Base
  VALID_INSTITUTION_CODES = Institutions.institutions.keys.map(&:to_s)

  devise :omniauthable, omniauth_providers: [:nyulibraries]

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
