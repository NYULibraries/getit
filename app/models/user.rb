class User < ActiveRecord::Base
	serialize :user_attributes  

	acts_as_authentic do |c|
		c.validations_scope = :username
		c.validate_password_field = false
		c.require_password_confirmation = false  
		c.disable_perishable_token_maintenance = true
	end
end
