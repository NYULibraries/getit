require "rails_helper"
describe HoldingRequestsHelper, vcr: {cassette_name: 'holding requests'} do
  let(:_service_response) { create(:nyu_aleph_service_response) }
  let(:_holding) { GetIt::Holding::NyuAleph.new(_service_response) }
  let(:_user) { build(:aleph_user) }
  let(:_holding_request) { HoldingRequest.new(_holding, _user) }
  before { assign(:holding_request, _holding_request)}
  describe '#title' do
    subject { helper.title }
    it { should be_a HoldingRequest::Title }
  end
  describe '#options' do
    subject { helper.options }
    it { should be_a HoldingRequest::Options }
  end
  describe '#pickup_locations' do
    subject { helper.pickup_locations }
    it { should be_a HoldingRequest::PickupLocations }
  end
  describe '#request_form' do
    let(:type) { :available }
    subject { helper.request_form(type) { 'block' } }
    it { should match /<form/}
    it { should match /<form/}
    it { should match /id="holding-request-#{type}"/}
    it { should match /id="type"/}
    it { should match /name="type"/}
    it { should match /value="#{type}"/}
  end
  describe '#request_option' do
    let(:type) { :available }
    subject { helper.request_option(type) { 'block' } }
    it { should eq "<li id=\"holding-request-option-#{type}\"><div class=\"section\">block</div></li>" }
  end
  describe '#request_link_or_text' do
    let(:text) { 'text' }
    let(:type) { :available }
    subject { helper.request_link_or_text(text, type) }
    context 'when there are no pickup locations' do
      before { assign(:pickup_locations, [])}
      #it should return with a link to the holding's sub library
      it { should match /href="http:\/\/test.host\/holding_requests\/#{_service_response.id}\/available\/BOBST"/ }
      it { should match /class="ajax_window"/ }
      it { should match /target="_blank"/ }
      it { should match /text/ }
    end
    context 'when there is only one pickup location' do
      let(:_service_response) { create(:single_pickup_location_nyu_aleph_service_response) }
      it { should match /href="http:\/\/test.host\/holding_requests\/#{_service_response.id}\/available\/BOBST"/ }
      it { should match /class="ajax_window"/ }
      it { should match /target="_blank"/ }
      it { should match /text/ }
    end
    context 'when there are multiple pickup locations' do
      it { should eq 'text'}
    end
  end
  describe '#entire_request_option' do
    let(:type) { :available }
    subject { helper.entire_request_option(type) }
    it { should match /for="entire_yes"/}
    it { should match /id="entire_yes"/}
    it { should match /type="radio"/}
    context 'when there is only one pickup location' do
      let(:_service_response) { create(:single_pickup_location_nyu_aleph_service_response) }
      it do
        should eq '<li id="holding-request-option-available-entire">' +
          '<div class="section">' +
            '<label class="radio" for="entire_yes">' +
              '<input checked="checked" id="entire_yes" name="entire" type="radio" value="yes" />' +
              'Request this item to be delivered to the pickup location of your choice.' +
            '</label>' +
            '<fieldset style="padding-left: 20px;">' +
              '<strong>Pickup location is NYU Bobst.</strong>' +
              '<input id="pickup_location" name="pickup_location" type="hidden" value="BOBST" />' +
            '</fieldset>' +
          '</div>' +
        '</li>'
      end
    end
    context 'when there are multiple pickup locations' do
      it do
        should eq '<li id="holding-request-option-available-entire">' +
          '<div class="section">' +
            '<label class="radio" for="entire_yes">' +
              '<input checked="checked" id="entire_yes" name="entire" type="radio" value="yes" />' +
              'Request this item to be delivered to the pickup location of your choice.' +
              '<p class="delivery-times">' +
                '<a href="http://library.nyu.edu/services/deliveryservices.html#how_long" target="_blank">' +
                  'See delivery times' +
                '</a>' +
              '</p>' +
            '</label>' +
            '<fieldset style="padding-left: 20px;">' +
              '<label for="pickup_location">Select pickup location:</label>' +
              '<select id="pickup_location" name="pickup_location">' +
              "<option value=\"BOBST\">NYU Bobst</option>\n" +
              "<option value=\"NCOUR\">NYU Courant</option>\n" +
              "<option value=\"NIFA\">NYU Institute of Fine Arts</option>\n" +
              "<option value=\"NISAW\">NYU Inst Study Ancient World</option>\n" +
              "<option value=\"NREI\">NYU Jack Brause</option>\n" +
              "<option value=\"NPOLY\">NYU Poly</option>\n" +
              "<option value=\"NYUAB\">NYU Abu Dhabi Library (UAE)</option>\n" +
              "<option value=\"NYUSE\">NYUAD Ctr for Sci &amp; Eng (UAE)</option>\n" +
              "<option value=\"NYUSS\">NYUAD Sama Fac Offices (UAE)</option>\n" +
              '<option value="NYUSX">NYU Shanghai Library (China)</option>' +
              '</select>' +
            '</fieldset>' +
          '</div>' +
        '</li>'
      end
    end
  end
  describe '#scan_request_option' do
    let(:type) { :available }
    subject { helper.scan_request_option(type) }
    it { should match /for="entire_no"/}
    it { should match /id="entire_no"/}
    it { should match /type="radio"/}
    it do
      should eq '<li id="holding-request-option-available-scan">' +
        '<div class="section">' +
          '<label class="radio" for="entire_no">' +
            '<input id="entire_no" name="entire" type="radio" value="no" />' +
            'Request that a portion of the item be scanned and delivered electronically.' +
            '<p class="fair-use-disclaimer">' +
              '(Requests must be within <a href="http://library.nyu.edu/copyright/#fairuse" target="_blank">fair use guidelines</a>.)' +
            '</p>' +
          '</label>' +
          '<fieldset style="padding-left: 20px;">' +
            '<label for="sub_author">Author of part:</label>' +
            '<input id="sub_author" name="sub_author" type="text" />' +
            '<label for="sub_title">Title of part:</label>' +
            '<input id="sub_title" name="sub_title" type="text" />' +
            '<label for="pages">Pages (e.g., 7-12; 5, 6-8, 10-15):</label>' +
            '<input id="pages" name="pages" type="text" />' +
            '<label for="note_1">Notes:</label>' +
            '<input id="note_1" maxlength="50" name="note_1" type="text" />' +
          '</fieldset>' +
        '</div>' +
      '</li>'
    end
  end
  describe '#pickup_locations_field_set' do
    subject { helper.pickup_locations_field_set }
    context 'when there are no pickup locations' do
      before { assign(:pickup_locations, [])}
      it do
        should eq '<fieldset>' +
          '<strong>Pickup location is NYU Bobst.</strong>' +
          '<input id="pickup_location" name="pickup_location" type="hidden" value="BOBST" />' +
        '</fieldset>'
      end
    end
    context 'when there is only one pickup location' do
      let(:_service_response) { create(:single_pickup_location_nyu_aleph_service_response) }
      it do
        should eq '<fieldset>' +
          '<strong>Pickup location is NYU Bobst.</strong>' +
          '<input id="pickup_location" name="pickup_location" type="hidden" value="BOBST" />' +
        '</fieldset>'
      end
    end
    context 'when there are multiple pickup locations' do
      it do
        should eq '<fieldset>' +
          '<label for="pickup_location">Select pickup location:</label>' +
          '<select id="pickup_location" name="pickup_location">' +
            "<option value=\"BOBST\">NYU Bobst</option>\n" +
            "<option value=\"NCOUR\">NYU Courant</option>\n" +
            "<option value=\"NIFA\">NYU Institute of Fine Arts</option>\n" +
            "<option value=\"NISAW\">NYU Inst Study Ancient World</option>\n" +
            "<option value=\"NREI\">NYU Jack Brause</option>\n" +
            "<option value=\"NPOLY\">NYU Poly</option>\n" +
            "<option value=\"NYUAB\">NYU Abu Dhabi Library (UAE)</option>\n" +
            "<option value=\"NYUSE\">NYUAD Ctr for Sci &amp; Eng (UAE)</option>\n" +
            "<option value=\"NYUSS\">NYUAD Sama Fac Offices (UAE)</option>\n" +
            '<option value="NYUSX">NYU Shanghai Library (China)</option>' +
          '</select>' +
        '</fieldset>'
      end
    end
  end
  describe '#scan_field_set' do
    subject { helper.scan_field_set }
    it do
      should eq '<fieldset>' +
        '<label for="sub_author">Author of part:</label>' +
        '<input id="sub_author" name="sub_author" type="text" />' +
        '<label for="sub_title">Title of part:</label>' +
        '<input id="sub_title" name="sub_title" type="text" />' +
        '<label for="pages">Pages (e.g., 7-12; 5, 6-8, 10-15):</label>' +
        '<input id="pages" name="pages" type="text" />' +
        '<label for="note_1">Notes:</label>' +
        '<input id="note_1" maxlength="50" name="note_1" type="text" />' +
      '</fieldset>'
    end
  end
  describe '#delivery_times' do
    subject { helper.delivery_times }
    context 'when there is only one pickup location' do
      let(:_service_response) { create(:single_pickup_location_nyu_aleph_service_response) }
      it { should be_blank }
    end
    context 'when there are multiple pickup locations' do
      it { should_not be_blank }
      it do
        should eq '<p class="delivery-times">' +
          '<a href="http://library.nyu.edu/services/deliveryservices.html#how_long" target="_blank">'+
          'See delivery times</a>' +
        '</p>'
      end
    end
  end
  describe '#fair_use_disclaimer' do
    subject { helper.fair_use_disclaimer }
    it do
      should eq '<p class="fair-use-disclaimer">' +
        '(Requests must be within ' +
        '<a href="http://library.nyu.edu/copyright/#fairuse" target="_blank">' +
        'fair use guidelines</a>.)' +
      '</p>'
    end
  end
  describe '#delivery_help' do
    subject { helper.delivery_help }
    context 'when there is only one option' do
      let(:_service_response) { build(:ill_nyu_aleph_service_response) }
      context 'because user does not have ill or ezborrow privileges' do
        let(:_user) { build(:non_ezborrow_user) }
        it { should be_blank }
      end
    end
  end
  describe '#available_request_text' do
    subject { helper.available_request_text }
    it { should eq 'Request this item to be delivered to the pickup location of your choice.'}
    context 'when the holding is in Abu Dhabi' do
      let(:_service_response) { build(:abu_dhabi_nyu_aleph_service_response) }
      it { should eq 'Request this item. It will be held for you at the specified pickup location. Items are ready for pickup within 2 business days.'}
    end
    context 'when the holding is at the Avery Fisher Center' do
      let(:_service_response) { build(:avery_fisher_nyu_aleph_service_response) }
      it { should eq 'Request this item for pick up at the Avery Fisher Center on the 2nd floor of the Bobst Library (NYC) or the NYU Abu Dhabi Library (UAE).'}
    end
  end
end
