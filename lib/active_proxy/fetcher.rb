# frozen_string_literal: true

module ActiveProxy
  class Fetcher
    attr_reader :proxy_key, :options, :cache_store

    def initialize(proxy_key, cache_store, options = {})
      @proxy_key = proxy_key
      @cache_store = cache_store
      @options = options
    end

    def format_proxy_httparty
      proxy = current_proxy
      { http_proxyaddr: proxy[:address], http_proxyport: proxy[:port], timeout: 4 }
    end

    def format_proxy_full
      proxy = current_proxy

      "#{proxy[:type]}://#{proxy[:address]}:#{proxy[:port]}"
    end

    def format_proxy_typhoeus
      { proxy: format_proxy_full }
    end

    def format_proxy_http
      proxy = current_proxy
      [proxy[:address], proxy[:port]]
    end

    def current_proxy
      proxy = cache_store.fetch(cache_key("current")) do
        _proxy = proxy_list.sample
        log_message "Got new proxy #{_proxy}"
        _proxy
      end
      return proxy unless proxy.nil?
      cache_store.delete(cache_key("list"))
      current_proxy
    end

    def user_agent
      UserAgentRandomizer::UserAgent.fetch.string
    end

    private

      def cache_key(item_name)
        "HTTP-PROXY-#{proxy_key}-#{Process.pid}-#{item_name}"
      end

      def proxy_list
        allowed_schemes = %w[http https]

        cache_store.fetch(cache_key("list")) do
          ProxyFetcher::Manager.new(proxy_manager_options).proxies.map do |proxy|
            scheme = proxy.type.downcase
            next unless allowed_schemes.include?(scheme)

            { address: proxy.addr, port: proxy.port, type: proxy.type.downcase || "http" }
          end.tap(&:compact!)
        end
      end

      def call
        handler = proc do |exception, attempt_number, total_delay|
          log_message "Retry proxy, exception: #{exception.class}"
          log_message exception.message[0..100]
          log_message "retry attempt #{attempt_number}; #{total_delay.to_i} seconds have passed."
          clear_current_proxy
        end

        with_retries(max_tries: max_retries_options, handler: handler) do
          yield self
        end
      end

      def max_retries_options
        options[:max_retries] || 10
      end

      def proxy_manager_options
        options[:proxy_manager_options] || { filters: { maxtime: "200" } }
      end

      def clear_current_proxy
        new_list = proxy_list
        new_list.delete(current_proxy)
        cache_store.delete(cache_key("current"))
        cache_store.write(cache_key("list"), new_list)
      end

      def log_message(msg)
        return if ENV["LOG_ACTIVE_PROXY"].nil?
        p msg
      end
  end
end
