module PciProxy
  class Token < Base

    SANDBOX_ENDPOINT = 'https://api.sandbox.datatrans.com/upp/services/v1/inline/token'.freeze
    LIVE_ENDPOINT = 'https://api.datatrans.com/upp/services/v1/inline/token'.freeze

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
    # Perform a token API request to turn the specified +transaction_id+ into card and CVV tokens
    #
    # @param +return_payment_method+ (true/false) - whether or not to return the identified payment method (default: true)
    # @param +cvv_mandatory+ (true/false) - whether or not to consider the CVV alias should be mandatory (default: false)
    #
    # @raise [PciProxyAPIError] in cases where the API responds with a non-200 response code
    # @return [PciProxy::Model::TokenisedCard] wrapper object around the JSON response
    def execute(transaction_id:, return_payment_method: true, cvv_mandatory: false)
      raise "transaction_id is required" unless transaction_id && !transaction_id.empty?

      response = api_get(params: { transactionId: transaction_id, returnPaymentMethod: return_payment_method, mandatoryAliasCVV: cvv_mandatory })
      PciProxy::Model::TokenisedCard.new(response)
    end

  end
end
