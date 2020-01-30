module PciProxy
  module Model
    class CheckResult

      attr_reader :response, :status, :error, :auth_code, :transaction_id

      def initialize(response)
        @response = response
        @auth_code = response["acquirerAuthorizationCode"]
        @transaction_id = response["transactionId"]
        @error = response["error"]

        @status = @auth_code && @transaction_id && !@error ? :success : :error
      end

    end
  end
end
