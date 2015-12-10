# encoding: UTF-8
require 'active_support/log_subscriber'

module CacheQueryTrace
  class <<self
    attr_accessor :enabled
    attr_accessor :level
    attr_reader :lines
    attr_reader :trace_slice

    def lines=(lines)
      @lines = lines

      @trace_slice = if CacheQueryTrace.lines == 0
                       0..-1
                     else
                       0..(CacheQueryTrace.lines - 1)
                     end
    end
  end

  class LogSubscriber < ActiveSupport::LogSubscriber
    def initialize
      super

      CacheQueryTrace.enabled = false
      CacheQueryTrace.level = :app
      CacheQueryTrace.lines = 5

      if CacheQueryTrace.level != :app
        # Rails by default silences all backtraces that match Rails::BacktraceCleaner::APP_DIRS_PATTERN
        Rails.backtrace_cleaner.remove_silencers!
      end
    end

    def cache_read(event)
      if CacheQueryTrace.enabled
        cleaned_trace = clean_trace(caller)[CacheQueryTrace.trace_slice].join("\n     from ")
        debug("  ↳ " + cleaned_trace) unless cleaned_trace.blank?
      end
    end

    alias cache_write cache_read
    alias cache_delete cache_read
    alias cache_exist? cache_read

    alias read_fragment cache_read
    alias write_fragment cache_read
    alias exist_fragment? cache_read
    alias expire_fragment cache_read

    def clean_trace(trace)
      # Rails relies on backtrace cleaner to set the application root directory
      # filter. The problem is that the backtrace cleaner is initialized
      # before the application. This ensures that the value of `root` used by
      # the filter is set to the application root
      if Rails.backtrace_cleaner.instance_variable_get(:@root) == '/'
        Rails.backtrace_cleaner.instance_variable_set :@root, Rails.root.to_s
      end

      case CacheQueryTrace.level
      when :full
        trace
      when :rails
        Rails.respond_to?(:backtrace_cleaner) ? Rails.backtrace_cleaner.clean(trace) : trace
      when :app
        Rails.backtrace_cleaner.remove_silencers!
        Rails.backtrace_cleaner.add_silencer { |line| line !~ /^(app|lib|engines)\// }
        Rails.backtrace_cleaner.clean(trace)
      else
        raise ArgumentError, "Invalid CacheQueryTrace.level value '#{CacheQueryTrace.level}' - should be :full, :rails, or :app"
      end
    end

    attach_to :active_support
    attach_to :action_controller
  end
end
