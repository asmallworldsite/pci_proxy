module PciProxy
  module Model
    class TokenisedCard

      attr_reader :response, :pan_token, :cvv_token, :type_slug

      def initialize(response)
        @response = response
        @pan_token = response["aliasCC"]
        @cvv_token = response["aliasCVV"]
        @type_slug = slug_for(response["paymentMethod"])
      end

      private

      def slug_for(payment_method)
        return nil if payment_method.nil?

        case payment_method
        when 'VIS'
          :visa
        when 'ECA'
          :mastercard
        when 'AMX'
          :amex
        when 'DIN'
          :diners
        when 'DIS'
          :discovery
        when 'JCB'
          :jcb
        when 'ELO'
          :elo
        when 'CUP'
          :cup
        else
          :unknown
        end

      end
    end
  end
end