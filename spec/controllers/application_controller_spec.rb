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

  describe "#url_for" do
    context "given options hash" do
      subject{ controller.url_for(options) }

      context "with query params" do
        let(:options){ {controller: "resolve", action: "index", key: "value"} }

        context "with institution_param" do
          let(:institution_param){ :NYUAD }
          before { allow(controller).to receive(:institution_param).and_return institution_param }

          it { is_expected.to eq "http://test.host/resolve?key=value&umlaut.institution=NYUAD" }
        end

        context "without either param" do
          it { is_expected.to eq "http://test.host/resolve?key=value" }
        end
      end

      context "without query params" do
        let(:options){ {controller: "resolve", action: "index"} }

        context "with institution_param" do
          let(:institution_param){ :NYUAD }
          before { allow(controller).to receive(:institution_param).and_return institution_param }

          it { is_expected.to eq "http://test.host/resolve?umlaut.institution=NYUAD" }
        end

        context "without either param" do
          it { is_expected.to eq "http://test.host/resolve" }
        end
      end
    end

    context "given url string" do
      subject{ controller.url_for(url) }

      context "with query params" do
        let(:url){ "http://test.host/some/path?key=value" }

        context "with institution_param" do
          let(:institution_param){ :NYUAD }
          before { allow(controller).to receive(:institution_param).and_return institution_param }

          it { is_expected.to eq "http://test.host/some/path?key=value&umlaut.institution=NYUAD" }
        end

        context "without either param" do
          it { is_expected.to eq url }
        end
      end

      context "without query params" do
        let(:url){ "http://test.host/some/path" }

        context "with institution_param" do
          let(:institution_param){ :NYUAD }
          before { allow(controller).to receive(:institution_param).and_return institution_param }

          it { is_expected.to eq "http://test.host/some/path?umlaut.institution=NYUAD" }
        end

        context "without either param" do
          it { is_expected.to eq url }
        end
      end

      context "where url points to generic URI" do
        let(:url){ "generic-uri" }
        it { is_expected.to eq "generic-uri" }
      end
    end
  end

end
