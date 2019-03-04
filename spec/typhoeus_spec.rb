# frozen_string_literal: true

require "spec_helper"

describe Typhoeus do
  it "can fetch" do
    ActiveProxy.call("shared", SPEC_CACHE) do |proxy|
      options = proxy.format_proxy_typhoeus
      options[:timeout] = 2
      options[:followlocation] = true
      options[:headers] = {
        "Accept" => "application/json",
        "User-Agent" => proxy.user_agent
      }
      options[:method] = :get

      result = Typhoeus::Request.new("https://api.ipify.org?format=json", options).run.body
      result = JSON.parse(result)
      raise "not match" unless result["ip"] == proxy.current_proxy[:address]

      expect(result["ip"]).to eq(proxy.current_proxy[:address])
    end
  end
end
