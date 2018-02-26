require_relative 'initializable'

class Wegift::Response
  include Initializable

  STATUS = {:success => 'SUCCESS', :error => 'ERROR'}

  # Field Name Contents
  #
  # status        - The status of the transaction. Usually “SUCCESS” or “ERROR”
  # error_code    - The error code, i.e. SE002
  # error_string  - Description of the error code, i.e. Required field missing from request
  # error_details - Details of the particular error, i.e. Field "delivery" missing from request

  # global shared body
  attr_accessor :payload, :status, :error_code, :error_string, :error_details

  def is_successful?
    @status && @status.eql?(STATUS[:success])
  end

  def parse(response = {})
    # TODO: JSON responses, when requested?
    # let's fix that with a simpel catch all
    if response.success? && response['content-type'].eql?('application/json')
      @payload = JSON.parse(response.body)
      # TODO: @payload['status'] is only returned for orders! (products etc are plain objects)
      @status = @payload['status'] || STATUS[:success]
      @error_code = @payload['error_code']
      @error_string = @payload['error_string']
      @error_details = @payload['error_details']
    else
      @payload = {}
      @status = STATUS[:error]
      @error_code = response.status
      @error_string = response.reason_phrase
      @error_details = response.reason_phrase
    end
  end

end
