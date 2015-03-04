class HoldingRequest
  attr_reader :holding, :user
  def initialize(holding, user)
    unless(holding.is_a?(GetIt::Holding::NyuAleph))
      raise ArgumentError.new("Expecting #{holding} to be a GetIt::Holding::NyuAleph")
    end
    unless(user.is_a?(User))
      raise ArgumentError.new("Expecting #{user} to be a User")
    end
    @holding = holding
    @user = user
  end

  def aleph_patron
    @aleph_patron ||= GetIt::AlephPatron.new(user)
  end

  def circulation_policy
    @circulation_policy ||= item.circulation_policy
  end

  def create_hold(parameters)
    item.create_hold(parameters)
  end

  private
  def item
    @item ||= record.item(item_id)
  end

  def record
    @record ||= aleph_patron.record(record_id)
  end

  def record_id
    @record_id ||= holding.record_id
  end

  def item_id
    @item_id ||= holding.item_id
  end
end
