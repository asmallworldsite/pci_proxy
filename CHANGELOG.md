# PciProxy Change Log

A simple client library for [PCI Proxy](https://pci-proxy.com)'s API

v1.2.3 - 26th May 2020 - Add support for masked_pan from tokenised card

v1.2.2 - 25th May 2020 - Fix bug in handling of card type where passed as a string rather than a symbol; Require rake 13.0 (CVE-2020-8130)

v1.2.1 - 30th January 2020 - Minor tweaks; cleanups; update documentation

v1.2.0 - 30th January 2020 - Add support for the [Check API](https://docs.pci-proxy.com/use-stored-cards/check)

v1.1.0 - 17th January 2020 - Return an instance of PciProxy::Model::TokenisedCard instead of plain Hash

v1.0.1 - 14th January 2020 - Relax dependency version requirements

v1.0.0 - 14th January 2020 - Initial release - covering the [Token API](https://docs.pci-proxy.com/collect-and-store-cards/capture-iframes/token-api)
