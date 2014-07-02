require 'rails_helper'
describe 'layouts/resolve' do
  let(:current_primary_institution) { Institutions.institutions[:NYU] }
  let(:url_for_request) { "http://url.for.request" }
  let(:current_user) { build(:aleph_user) }
  before do
    assign(:page_title, 'Page Title')
    allow(view).to receive(:current_primary_institution).and_return(current_primary_institution)
    allow(view).to receive(:umlaut_config).and_return(UmlautController.umlaut_config)
    allow(view).to receive(:url_for_request).and_return(url_for_request)
    allow(view).to receive(:current_user).and_return(current_user)
    params[:controller] = :resolve
    render
  end
  subject { rendered }
  it { should match /<title>GetIt | Page Title<title>/ }
  it { should match /class="umlaut no-js"/ }
  it { should match /class="umlaut-container"/ }
  it { should match /class="umlaut-main-container-fluid container-fluid umlaut-resolve-container/ }
  it { should render_template 'umlaut/_header' }
  it { should render_template 'umlaut/_footer' }
end
