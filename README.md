# ActiveProxy

![Alt text](https://travis-ci.com/sebyx07/active_proxy.svg?branch=master)
[![Gem Version](https://badge.fury.io/rb/active_proxy.svg)](https://badge.fury.io/rb/active_proxy)

### Easy to use ruby proxy fetcher with support for multiple http clients. Has auto retry🚀, fetch 🤖user agent


```ruby
gem 'active_proxy'
```

### Examples

#### HTTParty

```ruby
    cache = ActiveSupport::Cache::MemoryStore.new(size: 10.megabytes)

    ActiveProxy.call("ipify", cache) do |proxy| # for rails: ActiveProxy.call("ipify", Rails.cache) do |proxy|
      
      options = proxy.format_proxy_httparty
      options[:timeout] = 2
      options[:headers] = {
          "Accept" => "application/json",
          "User-Agent" => proxy.user_agent
      }

      result = HTTParty.get("https://api.ipify.org?format=json", options).body
      p JSON.parse(result)
      
    end
```

#### Http.rb

```ruby
    cache = ActiveSupport::Cache::MemoryStore.new(size: 10.megabytes)

    ActiveProxy.call("ipify", cache) do |proxy| # for rails: ActiveProxy.call("ipify", Rails.cache) do |proxy|
      
      proxy_arguments = proxy.format_proxy_http
      headers = {
        "Accept" => "application/json",
        "User-Agent" => proxy.user_agent
      }

      result = HTTP.via(*proxy_arguments)
                   .headers(headers)
                   .timeout(write: 2, connect: 1, read: 1)
                   .get("https://api.ipify.org?format=json")
                   .body

      p JSON.parse(result)      
      
    end
```

#### Typhoeus


```ruby
    cache = ActiveSupport::Cache::MemoryStore.new(size: 10.megabytes)

    ActiveProxy.call("ipify", cache) do |proxy| # for rails: ActiveProxy.call("ipify", Rails.cache) do |proxy|
      
      options = proxy.format_proxy_typhoeus
      options[:timeout] = 2
      options[:followlocation] = true
      options[:headers] = {
        "Accept" => "application/json",
        "User-Agent" => proxy.user_agent
      }
      options[:method] = :get

      result = Typhoeus::Request.new("https://api.ipify.org?format=json", options).run.body

      p JSON.parse(result)     
       
    end
```


#### custom client

```ruby
    cache = ActiveSupport::Cache::MemoryStore.new(size: 10.megabytes)

    ActiveProxy.call("ipify", cache) do |proxy| # for rails: ActiveProxy.call("ipify", Rails.cache) do |proxy|
      
      options = proxy.current_proxy
      # then you access the options[:address] and options[:port]
    end
```


### Custom options

#### User agent

When calling `.user_agent` you can pass params, check https://github.com/asconix/user-agent-randomizer

#### Limit retries

Current limit is 10.

Because proxies are unreliable, set a higher number

```ruby
    ActiveProxy.call("ipify", cache, {max_retries: 100}) do
    
    end
```


#### Proxy list

Current configuration is `{ filters: { maxtime: "200" } }`

You can check what configuration you can pass https://github.com/nbulaj/proxy_fetcher

```ruby
    ActiveProxy.call("ipify", cache, {proxy_manager_options: { filters: { maxtime: "100" } }}) do
    
    end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/active_proxy.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
