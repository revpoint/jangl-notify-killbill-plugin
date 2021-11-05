module JanglNotify
  module KillbillLoggerMixin
    attr_accessor :logger

    def logger=(logger)
      # logger is an OSGI LogService in the Killbill environment. For testing purposes,
      # allow delegation to a standard logger
      @logger = logger.respond_to?(:info) ? logger : Killbill::Plugin::KillbillLogger.new(logger)
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

  end
end
