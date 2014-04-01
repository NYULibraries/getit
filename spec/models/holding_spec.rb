require 'spec_helper'
describe Holding do
  let(:service_response) { }
  subject(:holding) { Holding.new(service_response) }
  it { should be_a Holding }
end
