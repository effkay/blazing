module Blazing
  module Base

    def log(type, message)
      @logger ||= Blazing::Logger.new
      @logger.log(type, message)
    end

    def report
      @logger.report
    end

  end
end
