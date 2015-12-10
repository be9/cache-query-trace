Logs the source of execution of cache queries to the Rails log. Helpful to
track down where queries are being executed in your application, for
performance optimizations most likely.

This gem is basically a modified version of
[active_record_query_trace](https://github.com/ruckus/active-record-query-trace).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cache-query-trace'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cache-query-trace

## Usage

Enable it in an initializer:

```ruby
CacheQueryTrace.enabled = true
```

## Options

There are three levels of debug.

1. app - includes only files in your app/ directory.
2. full - includes files in your app as well as rails.
3. rails - alternate output of full backtrace, useful for debugging gems.

```ruby
CacheQueryTrace.level = :app # default
```

Additionally, if you are working with a large app, you may wish to limit the number of lines displayed for each query.

```ruby
CacheQueryTrace.lines = 10 # Default is 5. Setting to 0 includes entire trace.
```

## Output

When enabled cache queries will be logged like:

```
Cache read: posts_count
  ↳ app/controllers/posts_controller.rb:3:in `index'
Read fragment views/posts/4-20151210094737092778000/8837ab4e4a7592addd66bce7a312e0e6 (3.1ms)
Cache write: views/posts/4-20151210094737092778000/8837ab4e4a7592addd66bce7a312e0e6
  ↳ app/views/posts/index.html.erb:5:in `block in _app_views_posts_index_html_erb__3444413509721278033_69855962868040'
     from app/views/posts/index.html.erb:4:in `_app_views_posts_index_html_erb__3444413509721278033_69855962868040'
  ↳ app/views/posts/index.html.erb:5:in `block in _app_views_posts_index_html_erb__3444413509721278033_69855962868040'
     from app/views/posts/index.html.erb:4:in `_app_views_posts_index_html_erb__3444413509721278033_69855962868040'
Write fragment views/posts/4-20151210094737092778000/8837ab4e4a7592addd66bce7a312e0e6 (16.4ms)
  Rendered posts/index.html.erb within layouts/application (184.0ms)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cache-query-trace. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

