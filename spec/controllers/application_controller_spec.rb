require 'rails_helper'
describe ApplicationController  do
  let(:request) { create(:available_request) }

  describe "#current_user_dev" do
    subject { controller.current_user_dev }
    it "should not raise any errors" do
      expect { subject }.to_not raise_error
    end
  end

  describe '#url_for_request' do
    subject { controller.url_for_request(request) }
    it { should eq "http://test.host/resolve?umlaut.request_id=#{request.id}"}
  end

  describe '#logout_path' do
    subject { controller.send(:logout_path) }
    it { should eql 'https://dev.login.library.nyu.edu/logout' }
  end

  describe '#passive_login_url' do
    subject { controller.send(:passive_login_url) }
    it { should include 'https://dev.login.library.nyu.edu/login/passive?client_id=' }
    it { should include '&return_uri=http%3A%2F%2Ftest.host' }
  end

  describe '#request_url_escaped' do
    subject { controller.send(:request_url_escaped) }
    it { should eql 'http%3A%2F%2Ftest.host' }
  end

  describe '#new_session_path' do
    subject { controller.send(:new_session_path, :user) }
    it { should eql '/login' }
  end

  describe '#after_sign_in_path_for' do
    subject { controller.send(:after_sign_in_path_for, :user) }
    it { should eql '/' }
  end

  describe '#after_sign_out_path_for' do
    subject { controller.send(:after_sign_out_path_for, :user) }
    context 'when LOGIN_URL is set in environment' do
      it { should eql 'https://dev.login.library.nyu.edu/logout' }
    end
    context 'when LOGIN_URL is null' do
      before { stub_const('ENV', ENV.to_hash.merge('LOGIN_URL' => nil)) }
      it { should eql '/' }
    end
  end

  describe '#institution_param' do
    subject { controller.send(:institution_param) }
    it { should eql nil }
  end

  describe '#routing_error' do
    let(:format) { nil }
    let(:path) { 'hack' }
    before { get :routing_error, path: path, format: format }
    subject { response.body }
    context 'when format is not specified' do
      it { should render_template('errors/404') }
    end
    context 'when format is JS' do
      let(:format) { 'js' }
      it { should eql '{"file":"/hack.js","error":"does not exist"}' }
    end
    context 'when format is JSON' do
      let(:format) { 'json' }
      it { should eql '{"file":"/hack.json","error":"does not exist"}' }
    end
    context 'when format is XML' do
      let(:format) { 'xml' }
      it { should include '<file>/hack.xml</file>' }
      it { should include '<error>does not exist</error>' }
    end
  end

end
