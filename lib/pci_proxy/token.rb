module PciProxy
  class Token < Base

    ##
    # Initialise with the specified +api_username+ and +api_password+ from PCI Proxy.
    def initialize(api_username:, api_password:)
      @api_endpoint = 'https://api.sandbox.datatrans.com/upp/services/v1/inline/token'.freeze
      @api_username = api_username
      @api_password = api_password
    end

    ##
    # Perform a token request to turn the specified +transaction_id+ into card and CVV tokens
    #
    # @param +return_payment_method+ (true/false) - whether or not to return the identified payment method (default: true)
    # @param +cvv_mandatory+ (true/false) - whether or not to consider the CVV alias should be mandatory (default: false)
    #
    # @raise [PciProxyAPIError] in cases where the API responds with a non-200 response code
    # @return [Hash] result from PCI Proxy, decoded from JSON
    def execute(transaction_id:, return_payment_method: true, cvv_mandatory: false)
      response = request(params: { transactionId: transaction_id, returnPaymentMethod: return_payment_method, mandatoryAliasCVV: cvv_mandatory })
      PciProxy::Model::TokenisedCard.new(response)
    end

  end
end
