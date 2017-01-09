module StackMapHelper
  def stackmap_policy(holding)
    StackMapPolicy.new(holding)
  end

  def stackmap_presenter(holding)
    StackMapPresenter.new(holding)
  end

  def stackmap?(institution)
    StackMapPolicy.mappable_institution?(institution)
  end
end
