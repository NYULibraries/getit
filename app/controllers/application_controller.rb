class ApplicationController < ActionController::Base
  protect_from_forgery
  include Authpds::Controllers::AuthpdsController
  # For dev purposes
  def current_user_dev
   @current_user_dev ||= User.find_by_username(Settings.seeds.user.username)
  end
  alias :current_user :current_user_dev if Rails.env.development?
end
