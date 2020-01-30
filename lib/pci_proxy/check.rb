module PciProxy
  class Check < Base

    SANDBOX_ENDPOINT = 'https://api.sandbox.datatrans.com/v1/transactions/validate'.freeze
    LIVE_ENDPOINT = 'https://api.datatrans.com/v1/transactions/validate'.freeze

    CHF = 'CHF'.freeze
    EUR = 'EUR'.freeze

    # error codes
    # "UNKNOWN_ERROR", "UNRECOGNIZED_PROPERTY", "INVALID_PROPERTY", "INVALID_TRANSACTION_STATUS", "TRANSACTION_NOT_FOUND", "INVALID_JSON_PAYLOAD", "UNAUTHORIZED", "EXPIRED_CARD", "INVALID_CARD", "UNSUPPORTED_CARD", "DUPLICATED_REFNO", "DECLINED", "BLOCKED_BY_VELOCITY_CHECKER", "CLIENT_ERROR" , "SERVER_ERROR"

    ##
    # Initialise with the specified +api_username+ and +api_password+ from PCI Proxy.
    #
    # Defaults to the sandbox API endpoint - to use the live environment,
    # supply the LIVE_ENDPOINT constant as the value of the +endpoint+ kwarg
    def initialize(api_username:, api_password:, endpoint: SANDBOX_ENDPOINT)
      @api_endpoint = endpoint
      @api_username = api_username
      @api_password = api_password
    end

    ##
    # Perform a check API request to verify the card token
    #
    # @param +reference+ [String] - caller's unique reference (any non-empty string value)
    # @param +card_token+ [String] - card token obtained from the Token API - see PciProxy::Token
    # @param +card_type+ [Symbol / String] - one of 'visa', 'mastercard' or 'amex'
    # @param +expiry_month+ [Integer / String] - integer 1-12, or string '01' - '12'
    # @param +expiry_year+ [Integer / String] - two or four digit year as a string or integer
    # @param +currency+ [Integer / String] (Optional) - one of 'CHF' or 'EUR' - will default by card type where not specified
    #
    # @raise [PciProxyAPIError] in cases where the API responds with a non-200 response code
    # @return [Hash] result from PCI Proxy, decoded from JSON
    def execute(reference:, card_token:, card_type:, expiry_month:, expiry_year:, currency: nil)
      raise "reference is required" if reference.empty?
      raise "card_token is required" unless card_token && !card_token.empty?
      raise "card_type must be one of 'visa', 'mastercard' or 'amex'" unless [:visa, :mastercard, :amex].include?(card_type.to_sym)
      raise "invalid expiry_month" unless (1..12).include?(expiry_month.to_i)
      raise "invalid expiry_year" unless expiry_year.to_i > 0

      # default the currency where not specified - according to the documentation Amex should use EUR, Visa and MC should use CHF
      currency ||= :amex == card_type ? EUR : CHF

      card = {
          alias: card_token,
          expiryMonth: expiry_month.to_s,
          expiryYear: expiry_year.to_s.chars.last(2).join
      }

      body = {
          refno: reference,
          currency: currency,
          card: card
      }

      api_post(endpoint: @api_endpoint, body: body)
    end

  end
end
