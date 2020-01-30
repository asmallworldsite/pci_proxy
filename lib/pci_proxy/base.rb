require 'faraday'
require 'multi_json'

module PciProxy
  class Base

    JSON_UTF8_CONTENT_TYPE = 'application/json; charset=UTF-8'.freeze

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
    # Perform an API request via HTTP GET
    #
    # @param +endpoint+ [String] (Optional) - the API endpoint to hit - defaults to the value of the api_endpoint reader
    # @param +params+ [Hash] (Optional) - any URL parameters to supply to the API call
    #
    # @raise [PciProxyAPIError] in cases where the API responds with a non-200 response code
    # @return [Hash] parsed JSON response
    def api_get(endpoint: @api_endpoint, params: {}, raise_on_error: true)
      response = client.get(endpoint, params)

      if raise_on_error == false || response.status == HTTP_OK_CODE
        return MultiJson.load(response.body)
      end

      raise error_class(response), "HTTP status: #{response.status}, Response: #{response.body}"
    end

    ##
    # Perform an API request via HTTP POST
    #
    # @param +endpoint+ [String] (Optional) - the API endpoint to hit - defaults to the value of the api_endpoint reader
    # @param +body+ [Hash] (Optional) - the API request payload (will be converted to JSON)
    #
    # @raise [PciProxyAPIError] in cases where the API responds with a non-200 response code
    # @return [Hash] parsed JSON response
    def api_post(endpoint: @api_endpoint, body: {}, raise_on_error: true)
      response = client.post(endpoint, MultiJson.dump(body), "Content-Type" => JSON_UTF8_CONTENT_TYPE)

      if raise_on_error == false || response.status == HTTP_OK_CODE
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