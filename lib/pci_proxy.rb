require 'bundler'
require "pci_proxy/version"

require 'pci_proxy/base'
require 'pci_proxy/check'
require 'pci_proxy/token'
require 'pci_proxy/model/tokenised_card'

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

end
