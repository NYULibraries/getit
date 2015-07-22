require 'rails_helper'
module GetIt
  module Holding
    describe NyuAleph do
      describe NyuAleph::VALID_SOURCES do
        subject { NyuAleph::VALID_SOURCES }
        it { should eq ['nyu_aleph', 'COURSES'] }
      end
      let(:service_response) { build(:nyu_aleph_service_response) }
      subject(:holding) { NyuAleph.new(service_response) }
      it { should be_a Base }
      it { should be_a PrimoSource }
      it { should be_a NyuAleph }
      describe '#service_response' do
        subject { holding.service_response }
        it { should be_a ServiceResponse }
        it { should be service_response }
      end
      describe '#record_id' do
        subject { holding.record_id }
        it { should_not be_nil }
      end
      describe '#item_id' do
        subject { holding.item_id }
        it { should_not be_nil }
      end
      describe '#location' do
        subject { holding.location}
        it { should_not be_nil }
      end
      describe '#sub_library' do
        subject { holding.sub_library}
        it { should_not be_nil }
        it { should be_an Exlibris::Aleph::SubLibrary }
      end
      describe '#collection' do
        subject { holding.collection}
        it { should_not be_nil }
        it { should be_an Exlibris::Aleph::Collection }
      end
      describe '#call_number' do
        subject { holding.call_number}
        it { should_not be_nil }
        it { should be_an Exlibris::Nyu::Aleph::CallNumber }
      end
      describe '#status' do
        subject { holding.status}
        it { should_not be_nil }
        it { should be_an Exlibris::Nyu::Aleph::Status }
        context 'when the holding is on the shelf' do
          let(:service_response) { build(:on_shelf_nyu_aleph_service_response) }
          it 'should equal "Available"' do
            expect("#{subject}").to eq 'Available'
          end
        end
        context 'when the holding is available' do
          let(:service_response) { build(:available_nyu_aleph_service_response) }
          it 'should equal "Available"' do
            expect("#{subject}").to eq 'Available'
          end
        end
        context 'when the holding is checked out' do
          let(:service_response) { build(:checked_out_nyu_aleph_service_response) }
          it 'should equal "Due: 06/28/14"' do
            expect("#{subject}").to eq 'Due: 06/28/14'
          end
        end
        context 'when the holding is billed as lost' do
          let(:service_response) { build(:billed_as_lost_nyu_aleph_service_response) }
          it 'should equal "Request ILL"' do
            expect("#{subject}").to eq 'Request ILL'
          end
        end
        context 'when the holding is claimed returned' do
          let(:service_response) { build(:claimed_returned_nyu_aleph_service_response) }
          it 'should equal "Request ILL"' do
            expect("#{subject}").to eq 'Request ILL'
          end
        end
        context 'when the holding is reshelving' do
          let(:service_response) { build(:reshelving_nyu_aleph_service_response) }
          it 'should equal "Reshelving"' do
            expect("#{subject}").to eq 'Reshelving'
          end
        end
      end
      describe '#edition' do
        subject { holding.edition}
        it { should_not be_nil }
      end
      describe '#notes' do
        subject { holding.notes}
        it { should_not be_nil }
      end
      describe '#coverage' do
        subject { holding.coverage}
        it { should_not be_nil }
      end
      describe '#reliability' do
        subject { holding.reliability}
        it { should_not be_nil }
      end
      describe '#recall_period' do
        subject { holding.recall_period}
        it { should_not be_nil }
      end
      describe '#from_aleph?' do
        subject { holding.from_aleph?}
        it { should_not be_nil }
        it { should be true }
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#requestable?' do
        subject { holding.requestable?}
        it { should_not be_nil }
        it { should be true }
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#ill?' do
        subject { holding.ill?}
        it { should_not be_nil }
        context 'when the holding is billed as lost' do
          let(:service_response) { build(:billed_as_lost_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is checked out' do
          let(:service_response) { build(:checked_out_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is on the shelf' do
          let(:service_response) { build(:available_nyu_aleph_service_response) }
          it { should be false }
        end
        context 'when the holding is available' do
          let(:service_response) { build(:on_shelf_nyu_aleph_service_response) }
          it { should be false }
        end
        context 'when the holding is offsite' do
          let(:service_response) { build(:offsite_nyu_aleph_service_response) }
          it { should be false }
        end
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#checked_out?' do
        subject { holding.checked_out?}
        it { should_not be_nil }
        context 'when the holding is checked out' do
          let(:service_response) { build(:checked_out_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#available?' do
        subject { holding.available?}
        it { should_not be_nil }
        context 'when the holding is on the shelf' do
          let(:service_response) { build(:on_shelf_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is available' do
          let(:service_response) { build(:available_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#offsite?' do
        subject { holding.offsite?}
        it { should_not be_nil }
        context 'when the holding is checked out' do
          let(:service_response) { build(:offsite_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#processing?' do
        subject { holding.processing?}
        it { should_not be_nil }
        context 'when the holding is processing' do
          let(:service_response) { build(:processing_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#reshelving?' do
        subject { holding.reshelving?}
        it { should_not be_nil }
        context 'when the holding is reshelving' do
          let(:service_response) { build(:reshelving_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#requested?' do
        subject { holding.requested?}
        it { should_not be_nil }
        context 'when the holding is requested' do
          let(:service_response) { build(:requested_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#on_order?' do
        subject { holding.on_order?}
        it { should_not be_nil }
        context 'when the holding is on order' do
          let(:service_response) { build(:on_order_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#bobst_reserve?' do
        subject { holding.bobst_reserve? }
        it { should_not be_nil }
        context 'when the holding is from the NYU Bobst Reserve Collection' do
          let(:service_response) { build(:bobst_reserve_nyu_aleph_service_response) }
          it { should be true }
        end
        context 'when the holding is not from the NYU Bobst Reserve Collection' do
          let(:service_response) { build(:avery_fisher_nyu_aleph_service_response) }
          it { should be false }
        end
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe "#afc_schedulable?" do
        subject { holding.afc_schedulable? }
        context 'when the holding is from the AFC' do
          context 'and the holding is from the Main Collection' do
            let(:service_response) { build(:avery_fisher_nyu_aleph_service_response) }
            it { should be true }
          end
          context 'but the holding is not from the Main Collection' do
            let(:service_response) { build(:avery_fisher_not_main_nyu_aleph_service_response) }
            it { should be false }
          end
        end
        context 'when the holding is not from the AFC' do
          let(:service_response) { build(:bobst_reserve_nyu_aleph_service_response) }
          it { should be false }
        end
        context 'when the holding is not from Aleph' do
          let(:service_response) { build(:nyu_aleph_not_from_aleph_service_response) }
          it { should be false }
        end
      end
      describe '#institution' do
        subject { holding.institution }
        it { should_not be_nil }
      end
      context 'when initialized with a service response argument' do
        context 'and the service response argument is an "NYU_Primo_Source" ServiceResponse' do
          context 'but the service response argument is not a valid NyuAleph Primo source' do
            let(:service_response) { build(:primo_source_service_response) }
            it 'should raise an ArgumentError' do
              expect { subject }.to raise_error ArgumentError
            end
          end
          context 'but the service response argument does not have source data' do
            let(:service_response) { build(:nyu_aleph_service_response_without_source_data) }
            it 'should raise an ArgumentError' do
              expect { subject }.to raise_error ArgumentError
            end
          end
        end
      end
    end
  end
end
