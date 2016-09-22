module AFCScheduleHelper
  def can_afc_schedule?
    current_user.present? && afc_schedule_authorizer.authorized?
  end

  def afc_schedule_url
    @afc_schedule_url ||= 'https://nyu.qualtrics.com/jfe/form/SV_eKBzul896KmAWVL'
  end

  private
  def afc_schedule_authorizer
    @afc_schedule_authorizer ||= AFCScheduleAuthorizer.new(current_user)
  end
end
