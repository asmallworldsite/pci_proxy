require 'bundler'
require "pci_proxy/version"
require 'faraday'
require 'multi_json'

module PciProxy
  PciProxyAPIError = Class.new(StandardError)
  BadRequestError = Class.new(PciProxyAPIError)
  UnauthorizedError = Class.new(PciProxyAPIError)
  ForbiddenError = Class.new(PciProxyAPIError)
  NotFoundError = Class.new(PciProxyAPIError)
  UnprocessableEntityError = Class.new(PciProxyAPIError)

  HTTP_OK_CODE = 200

  HTTP_BAD_REQUEST_CODE = 400
  HTTP_UNAUTHORIZED_CODE = 401
  HTTP_FORBIDDEN_CODE = 403
  HTTP_NOT_FOUND_CODE = 404
  HTTP_UNPROCESSABLE_ENTITY_CODE = 429

  class Client

    DEFAULT_API_ENDPOINT = 'https://api.sandbox.datatrans.com/upp/services/v1/inline/token'.freeze

    attr_reader :api_endpoint, :api_username, :api_password

    def initialize(api_username:, api_password:, api_endpoint: nil)
      @api_endpoint = api_endpoint || DEFAULT_API_ENDPOINT
      @api_username = api_username
      @api_password = api_password
    end

    def token(transaction_id:)
      request(params: { transactionId: transaction_id, returnPaymentMethod: true, mandatoryAliasCVV: true })
    end

    private

    def client
      @client ||= Faraday.new(@api_endpoint) do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
        client.basic_auth(@api_username, @api_password)
      end
    end

    def request(endpoint: @api_endpoint, http_method: :get, params: {})
      response = client.public_send(http_method, endpoint, params)

      if response_successful?(response)
        return MultiJson.load(response.body)
      end

      raise error_class(response), "HTTP status: #{response.status}, Response: #{response.body}"
    end

    def response_successful?(response)
      response.status == HTTP_OK_CODE
    end

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
