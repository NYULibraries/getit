class ApplicationController < ActionController::Base
  protect_from_forgery
  include Authpds::Controllers::AuthpdsController
end