class User < ActiveRecord::Base
  require 'exlibris-aleph'

  attr_accessible :crypted_password, :current_login_at, :current_login_ip, :email, :firstname,
    :last_login_at, :last_login_ip, :last_request_at, :lastname, :login_count, :mobile_phone,
      :password_salt, :persistence_token, :refreshed_at, :session_id, :username
  serialize :user_attributes

  acts_as_authentic do |c|
    c.validations_scope = :username
    c.validate_password_field = false
    c.require_password_confirmation = false
    c.disable_perishable_token_maintenance = true
  end

  # Create a hold in Aleph on the given holding for user
  def create_hold(holding, hold_options)
    patron.place_hold(holding.adm_library_code, holding.original_source_id, 
      holding.source_record_id, holding.item_id, hold_options)
  end

  # Return the error from the Aleph patron.
  def error
    patron.error
  end

  # Aleph Patron for placing holds
  def patron
    @patron ||= Exlibris::Aleph::Patron.new(patron_id: user_attributes[:nyuidn])
  end
  private :patron
end
