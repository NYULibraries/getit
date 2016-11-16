require "rails_helper"
describe ApplicationHelper, vcr: {cassette_name: 'holdings'} do
  let(:request) { create(:available_request) }
  let(:institutional_services) { Institutions.institutions[:NYU].services }
  let(:services) do
    institutional_services.select do |id, definition|
      ['NYU_Primo', 'NYU_Primo_Source'].include?(id)
    end
  end
  let(:collection) { Collection.new(request, services) }
  before { collection.dispatch_services! }
  describe '#destroy_successful_nyu_primo_source_dispatched_services' do
    subject do
      helper.destroy_successful_nyu_primo_source_dispatched_services(request)
    end
    context 'when all the services have not run' do
      it 'should destroy only NYU_Primo_Sources' do
        if request.any_services_in_progress?
          subject
          nyu_primo_sources =
            request.dispatched_services.where(service_id: 'NYU_Primo_Source')
          expect(nyu_primo_sources).not_to be_empty
          nyu_primos = request.dispatched_services.where(service_id: 'NYU_Primo')
          expect(nyu_primos).not_to be_empty
        else
          pending('All service ran')
        end
      end
    end
    context 'when all the services have run' do
      before do
        while request.any_services_in_progress? do
          # Wait for half a second
          sleep 0.5
          # Reload from the DB
          request.reload
        end
      end
      it 'should destroy only NYU_Primo_Sources' do
        subject
        nyu_primo_sources =
          request.dispatched_services.where(service_id: 'NYU_Primo_Source')
        expect(nyu_primo_sources).to be_empty
        nyu_primos = request.dispatched_services.where(service_id: 'NYU_Primo')
        expect(nyu_primos).not_to be_empty
      end
    end
  end
  describe '#destroy_expired_nyu_primo_source_service_responses' do
    before do
      while request.any_services_in_progress? do
        # Wait for half a second
        sleep 0.5
        # Reload from the DB
        request.reload
      end
    end
    it 'should expire NYU Primo Sources when run once' do
      nyu_primo_source_service_responses =
        request.service_responses.where(service_id: 'NYU_Primo_Source')
      nyu_primo_source_service_responses.each do |service_response|
        service_response.reload
        holding = GetIt::HoldingManager.new(service_response).holding
        expect(holding.expired?).to be false
      end
      helper.expire_or_destroy_nyu_primo_source_service_responses(request)
      nyu_primo_source_service_responses.each do |service_response|
        service_response.reload
        holding = GetIt::HoldingManager.new(service_response).holding
        expect(holding.expired?).to be true
      end
    end
    it 'should destroy NYU Primo Sources when run twice' do
      nyu_primo_source_service_responses =
        request.service_responses.where(service_id: 'NYU_Primo_Source')
      nyu_primo_source_service_responses.each do |service_response|
        service_response.reload
        holding = GetIt::HoldingManager.new(service_response).holding
        expect(holding.expired?).to be false
      end
      helper.expire_or_destroy_nyu_primo_source_service_responses(request)
      helper.expire_or_destroy_nyu_primo_source_service_responses(request)
      nyu_primo_source_service_responses.reload
      expect(nyu_primo_source_service_responses).to be_empty
    end
  end

  describe "url_for" do
    context "given options hash" do
      subject{ helper.url_for(options) }

      context "with query params" do
        let(:options){ {controller: "resolve", action: "index", key: "value"} }

        context "with institution_param" do
          let(:institution_param){ :NYUAD }
          before { allow(helper).to receive(:institution_param).and_return institution_param }

          it { is_expected.to eq "/resolve?key=value&umlaut.institution=NYUAD" }
        end

        context "without either param" do
          it { is_expected.to eq "/resolve?key=value" }
        end
      end

      context "without query params" do
        let(:options){ {controller: "resolve", action: "index"} }

        context "with institution_param" do
          let(:institution_param){ :NYUAD }
          before { allow(helper).to receive(:institution_param).and_return institution_param }

          it { is_expected.to eq "/resolve?umlaut.institution=NYUAD" }
        end

        context "without either param" do
          it { is_expected.to eq "/resolve" }
        end
      end
    end

    context "given url string" do
      subject{ helper.url_for(url) }

      context "with query params" do
        let(:url){ "https://example.com/some/path?key=value" }

        context "with institution_param" do
          let(:institution_param){ :NYUAD }
          before { allow(helper).to receive(:institution_param).and_return institution_param }

          it { is_expected.to eq "https://example.com/some/path?key=value&umlaut.institution=NYUAD" }
        end

        context "without either param" do
          it { is_expected.to eq url }
        end
      end

      context "without query params" do
        let(:url){ "https://example.com/some/path" }

        context "with institution_param" do
          let(:institution_param){ :NYUAD }
          before { allow(helper).to receive(:institution_param).and_return institution_param }

          it { is_expected.to eq "https://example.com/some/path?umlaut.institution=NYUAD" }
        end

        context "without either param" do
          it { is_expected.to eq url }
        end
      end
    end
  end
end
