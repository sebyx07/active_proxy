# frozen_string_literal: true

require "spec_helper"

describe HTTParty do
  it "can fetch" do
    ActiveProxy.call("shared", SPEC_CACHE) do |proxy|
      options = proxy.format_proxy_httparty
      options[:timeout] = 2
      options[:headers] = {
          "Accept" => "application/json",
          "User-Agent" => proxy.user_agent
      }

      result = HTTParty.get("https://api.ipify.org?format=json", options).body
      result = JSON.parse(result)
      raise "not match" unless result["ip"] == proxy.current_proxy[:address]

      expect(result["ip"]).to eq(proxy.current_proxy[:address])
    end
  end
end
