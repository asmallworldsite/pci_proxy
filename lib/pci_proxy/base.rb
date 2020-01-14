require 'faraday'
require 'multi_json'

module PciProxy
  class Base

    attr_reader :api_endpoint, :api_username, :api_password

    ##
    # Create and memoise a Faraday client for this API client
    def client
      @client ||= Faraday.new(@api_endpoint) do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
        client.basic_auth(@api_username, @api_password)
      end
    end

    ##
    # Perform the API request
    #
    # @param +endpoint+ [String] (Optional) - the API endpoint to hit - defaults to the value of the api_endpoint reader
    # @param +http_method+ [Symbol] (Optional) - the HTTP method to use - defaults to GET
    # @param +params+ [Hash] (Optional) - any parameters to supply to the API call
    #
    # @raise [PciProxyAPIError] in cases where the API responds with a non-200 response code
    # @return [Hash] parsed JSON response
    #
    def request(endpoint: @api_endpoint, http_method: :get, params: {})
      response = client.public_send(http_method, endpoint, params)

      if response.status == HTTP_OK_CODE
        return MultiJson.load(response.body)
      end

      raise error_class(response), "HTTP status: #{response.status}, Response: #{response.body}"
    end

    ##
    # Fetch the error klass appropriate for the given Faraday +response+
    #
    # @param +response+ (Response) - the Faraday response object
    # @return [StandardError] - the StandardError subclass appropriate to the +response+
    def error_class(response)
      case response.status
      when HTTP_BAD_REQUEST_CODE
        BadRequestError
      when HTTP_UNAUTHORIZED_CODE
        UnauthorizedError
      when HTTP_FORBIDDEN_CODE
        ForbiddenError
      when HTTP_NOT_FOUND_CODE
        NotFoundError
      when HTTP_UNPROCESSABLE_ENTITY_CODE
        UnprocessableEntityError
      else
        PciProxyAPIError
      end
    end

  end
end