# frozen_string_literal: true

require "zeitwerk"
require "retries"
require "proxy_fetcher"
require "user_agent_randomizer"

Zeitwerk::Loader.for_gem.setup

module ActiveProxy
  class << self
    def call(proxy_key, cache_store, options = {})
      ActiveProxy::Fetcher.new(proxy_key, cache_store, options).send(:call) do |fetcher|
        yield fetcher
      end
    end
  end
end
