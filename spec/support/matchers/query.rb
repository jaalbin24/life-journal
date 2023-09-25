# =====================================================================
# This code was taken from https://github.com/civiccc/db-query-matchers
# =====================================================================

# Custom matcher to check for database queries performed by a block of code.
#
# @example
#   expect { subject }.to_not make_database_queries
#
# @example
#   expect { subject }.to make_database_queries(count: 1)
#
# @example
#   expect { subject }.to make_database_queries(manipulative: true)
#
# @example
#   expect { subject }.to make_database_queries(unscoped: true)
#
# @see DBQueryMatchers::QueryCounter

module DBQueryMatchers
  class << self
    attr_writer :configuration
  end

  # Gets the current configuration
  # @return [DBQueryMatchers::Configuration] the active configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Resets the current configuration.
  # @return [DBQueryMatchers::Configuration] the active configuration
  def self.reset_configuration
    @configuration = Configuration.new
  end

  # Updates the current configuration.
  # @example
  #   DBQueryMatchers.configure do |config|
  #     config.ignores = [/SELECT.*FROM.*users/]
  #   end
  #
  def self.configure
    yield(configuration)
  end
  # Configuration for the DBQueryMatcher module.
  class Configuration
    attr_accessor :ignores, :ignore_cached, :on_query_counted, :schemaless, :log_backtrace, :backtrace_filter, :db_event

    def initialize
      @db_event = "sql.active_record"
      @ignores = []
      @on_query_counted = Proc.new { }
      @schemaless = false
      @ignore_cached = false
      @log_backtrace = false
      @backtrace_filter = Proc.new { |backtrace| backtrace }
    end
  end
  # Counter to keep track of the number of queries caused by running a piece of
  # code. Closely tied to the `:make_database_queries` matcher, this class is
  # designed to be a consumer of `sql.active_record` events.
  #
  # @example
  #   counter = DBQueryMatchers::QueryCounter.new
  #   ActiveSupport::Notifications.subscribed(counter.to_proc,
  #                                          'sql.active_record') do
  #     # run code here
  #   end
  #   puts counter.count          # prints the number of queries made
  #   puts counter.log.join(', ') # prints all queries made
  #
  # @see http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html#module-ActiveSupport::Notifications-label-Temporary+Subscriptions
  class QueryCounter
    attr_reader :count, :log

    def initialize(options = {})
      @matches = options[:matches]
      @count = 0
      @log   = []
    end

    # Turns a QueryCounter instance into a lambda. Designed to be used when
    # subscribing to events through the ActiveSupport::Notifications module.
    #
    # @return [Proc]
    def to_proc
      lambda(&method(:callback))
    end

    # Method called from the ActiveSupport::Notifications module (through the
    # lambda created by `to_proc`) when an SQL query is made.
    #
    # @param _name       [String] name of the event
    # @param _start      [Time]   when the instrumented block started execution
    # @param _finish     [Time]   when the instrumented block ended execution
    # @param _message_id [String] unique ID for this notification
    # @param payload    [Hash]   the payload
    def callback(_name, _start,  _finish, _message_id, payload)
      return if @matches && !any_match?(@matches, payload[:sql])
      return if any_match?(DBQueryMatchers.configuration.ignores, payload[:sql])
      return if DBQueryMatchers.configuration.ignore_cached && payload[:cached]
      return if DBQueryMatchers.configuration.schemaless && payload[:name] == "SCHEMA"

      count_query
      log_query(payload[:sql])

      DBQueryMatchers.configuration.on_query_counted.call(payload)
    end

    private

    def any_match?(patterns, sql)
      patterns.any? { |pattern| sql =~ pattern }
    end

    def count_query
      @count += 1
    end

    def log_query(sql)
      log_entry = sql.strip

      if DBQueryMatchers.configuration.log_backtrace
        raw_backtrace = caller
        filtered_backtrace = DBQueryMatchers.configuration.backtrace_filter.call(raw_backtrace)
        log_entry += "\n#{filtered_backtrace.join("\n")}\n"
      end

      @log << log_entry
    end
  end
end

RSpec::Matchers.define :make_database_queries do |options = {}|
  if RSpec::Core::Version::STRING =~ /^2/
    def self.failure_message_when_negated(&block)
      failure_message_for_should_not(&block)
    end

    def self.failure_message(&block)
      failure_message_for_should(&block)
    end

    def supports_block_expectations?
      true
    end
  else
    supports_block_expectations
  end

  # Taken from ActionView::Helpers::TextHelper
  def pluralize(count, singular, plural = nil)
    word = if count == 1 || count.to_s =~ /^1(\.0+)?$/
             singular
           else
             plural || singular.pluralize
           end

    "#{count || 0} #{word}"
  end

  define_method :matches? do |block|
    counter_options = {}
    if options[:manipulative]
      counter_options[:matches] = [/^\ *(INSERT|UPDATE|DELETE\ FROM)/]
    end
    if options[:unscoped]
      counter_options[:matches] = [
        %r{
          (?:                         # Any of these appear
            SELECT(?!\sCOUNT).*FROM|  #   SELECT ... FROM (not SELECT ... COUNT)
            DELETE\sFROM|             #   DELETE ... FROM
            UPDATE.*SET               #   UPDATE ... SET
          )
          (?!.*(WHERE|LIMIT))         # Followed by WHERE and/or LIMIT
        }mx                           # Ignore whitespace and newlines
      ]
    end
    if options[:matching]
      counter_options[:matches] ||= []
      case options[:matching]
      when Regexp
        counter_options[:matches] << options[:matching]
      when String
        counter_options[:matches] << Regexp.new(Regexp.escape(options[:matching]))
      end
    end
    @counter = DBQueryMatchers::QueryCounter.new(counter_options)
    ActiveSupport::Notifications.subscribed(@counter.to_proc,
                                            DBQueryMatchers.configuration.db_event,
                                            &block)
    if absolute_count = options[:count]
      absolute_count === @counter.count
    else
      @counter.count > 0
    end
  end

  failure_message_when_negated do |_|
    <<-EOS
expected no queries, but #{@counter.count} were made:
#{@counter.log.join("\n")}
    EOS
  end

  failure_message do |_|
    if options[:count]
      expected = pluralize(options[:count], 'query')
      actual   = pluralize(@counter.count, 'was', 'were')

      output   = "expected #{expected}, but #{actual} made"
      if @counter.count > 0
        output += ":\n#{@counter.log.join("\n")}"
      end
      output
    else
      'expected queries, but none were made'
    end
  end
end