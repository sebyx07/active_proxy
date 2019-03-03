# frozen_string_literal: true

require "active_proxy"
require "typhoeus"
require "http"
require "httparty"
require "active_support/all"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expose_dsl_globally = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ENV["LOG_ACTIVE_PROXY"] = "true"
SPEC_CACHE ||= ActiveSupport::Cache::MemoryStore.new(size: 10.megabytes)
