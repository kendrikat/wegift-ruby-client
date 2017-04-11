class Wegift::Response

  STATUS = {:success => 'SUCCESS', :error => 'ERROR'}

  # Field Name Contents
  #
  # status        - The status of the transaction. Usually “SUCCESS” or “ERROR”
  # error_code    - The error code, i.e. SE002
  # error_string  - Description of the error code, i.e. Required field missing from request
  # error_details - Details of the particular error, i.e. Field "delivery" missing from request

  # global shared body
  attr_accessor :status, :error_code, :error_string, :error_details

  def is_successful?
    @status && @status.eql?(STATUS[:success])
  end

  def parse(data = {})
    @status = data['status']
    @error_code = data['error_code']
    @error_string = data['error_string']
    @error_details = data['error_details']
  end

  # TODO

end