require 'faraday'
require 'faraday/net_http' # Explicitly require the net_http adapter

Faraday.default_adapter = :net_http # or :excon, :typhoeus, etc., depending on your preference
