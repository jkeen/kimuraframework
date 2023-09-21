# Mixin for logging behavior
module Kimurai
  module Loggable
    require 'logger'
    extend ActiveSupport::Concern

    # => Grab the configured logger or instantiate default
    def self.logger
      @logger ||= Kimurai.configuration.logger || begin
                                                    STDOUT.sync
                                                    Logger.new(STDOUT,
                                                               formatter: formatter,
                                                               level: (Kimurai.env == "development" ? :debug : :warn),
                                                               progname: name)
                                                  end
    end

    # REVIEW: Does this work outside of the context of spider?
    def self.formatter
      proc do |severity, datetime, progname, msg|
        current_thread_id = Thread.current.object_id
        thread_type = Thread.main == Thread.current ? "M" : "C"
        # => `$$` Is the process number of ruby process running this script
        output = "%s, [%s#%d] [%s: %s] %5s -- %s: %s\n"
                   .freeze % [severity[0..0], datetime, $$, thread_type, current_thread_id, severity, progname, msg]
      end
    end

    # => When included add the logger method which gives access to the `logger` instance
    # => Global, memoized, lazy initialize instance of a logger
    included do
      def logger
        Loggable.logger
      end
    end
  end
end
