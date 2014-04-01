# Class to authorize holding requests for holding/user combination
class HoldingRequestAuthorizer
  # Required user permission constants
  AVAILABLE_REQUIRED_PERMISSIONS = { hold_permission: "Y", hold_on_shelf: "Y" }
  RECALLABLE_REQUIRED_PERMISSIONS = { hold_permission: "Y" }
  IN_PROCESSING_REQUIRED_PERMISSIONS = { hold_permission: "Y" }
  OFFSITE_REQUIRED_PERMISSIONS = { hold_permission: "Y" }
  ON_ORDER_REQUIRED_PERMISSIONS = { hold_permission: "Y" }

  attr_reader :holding, :user

  def initialize(holding, user)
    @holding = holding
    @user = user
  end

  # Is the holding/user combo requestable?
  def requestable?
    (ill? || available? || recallable? || in_processing? || on_order? || offsite?)
  end

  # Is an available request available for the holding/user combo?
  def available?
    (holding.available? && combo_requestable?(AVAILABLE_REQUIRED_PERMISSIONS))
  end

  # Is a recall request available for the holding/user combo?
  def recallable?
    (holding.recallable? && combo_requestable?(RECALLABLE_REQUIRED_PERMISSIONS))
  end
  alias_method :recall?, :recallable?

  # Is an in processing request available for the holding/user combo?
  def in_processing?
    (holding.in_processing? && combo_requestable?(IN_PROCESSING_REQUIRED_PERMISSIONS))
  end

  # Is an offsite request available for the holding/user combo?
  def offsite?
    (holding.offsite? && combo_requestable?(OFFSITE_REQUIRED_PERMISSIONS))
  end

  # Is an on order request available for the holding/user combo?
  def on_order?
    (holding.on_order? && combo_requestable?(ON_ORDER_REQUIRED_PERMISSIONS))
  end

  # Is an ILL request available for the holding/user combo?
  # We don't care about user permissions when we're dealing with ILL.
  def ill?
    holding.ill?
  end

  private
  # In order to determine if the combination of user and holding is requestable we need to check:
  #   1. if the holding is in a requestable state
  #   2. if user is authorized to make the request, i.e. has the required permissions
  def combo_requestable?(required_permissions)
    # If always requestable, we can return true even (especially) if user session is nil
    return true if (holding_always_requestable? and user.nil?)
    return (holding_requestable? and user_authorized?(required_permissions))
  end

  # Is the holding always requestable?
  def holding_always_requestable?
    holding.requestability ==
      Exlibris::Primo::Source::NyuAleph::Requestability::YES
  end

  # Is the holding requestable (possibly deferring the decision to whether the user can request)
  def holding_requestable?
    holding_always_requestable? || 
      holding.requestability == Exlibris::Primo::Source::NyuAleph::Requestability::DEFERRED
  end

  # Is the user authorized to make the request, i.e. does she have the required permissions?
  # Returns false if no user.
  # This is an AND test.
  def user_authorized?(required_permissions)
    return false if user.nil?
    required_permissions.each_pair do |required_permission, required_value|
      return false unless required_value == user_permissions[required_permission]
    end
    return true
  end

  # User permissions for the holding
  def user_permissions
    @user_permission ||= 
      user.aleph_permissions_by_sub_library_code(holding.adm_library_code, holding.sub_library_code)
  end
end
