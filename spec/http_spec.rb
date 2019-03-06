# frozen_string_literal: true

require "spec_helper"

describe HTTP do
  it "can fetch" do
    ActiveProxy.call("shared", SPEC_CACHE, unique_per_process: true) do |proxy|
      proxy_arguments = proxy.format_proxy_http
      p proxy_arguments
      headers = {
        "Accept" => "application/json",
        "User-Agent" => proxy.user_agent
      }

      result = HTTP.via(*proxy_arguments)
                   .headers(headers)
                   .timeout(write: 2, connect: 1, read: 1)
                   .get("https://api.ipify.org?format=json")
                   .body

      result = JSON.parse(result)
      raise "not match" unless result["ip"] == proxy.current_proxy[:address]

      expect(result["ip"]).to eq(proxy.current_proxy[:address])
    end
  end
end
