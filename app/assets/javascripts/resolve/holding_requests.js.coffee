$ ->
  scan_request_option_id = '#entire_no'
  scan_request_container_class = '#holding-request-option-offsite-scan'
  # Select scan request if any of the text inputs have a value
  $(document).on 'keypress', scan_request_container_class + ' fieldset input', ->
    $(this).closest('fieldset').prev('label').find('input').first().prop('checked', true)
  # Clear the text inputs for scan requests if option is unselected
  $(document).on 'change', 'input[type="radio"]', ->
    if !$(scan_request_option_id).is(':checked')
      $(scan_request_container_class + ' fieldset input').val('')
