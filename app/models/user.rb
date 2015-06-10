class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:nyulibraries]

end
