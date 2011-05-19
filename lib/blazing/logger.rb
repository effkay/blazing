module Blazing
  module Logger

    LOG_LEVELS =  [:info, :success, :warn, :error]

    def messages
      @messages ||= []
    end

    def log(type, message)
      if LOG_LEVELS.include? type
        messages << Hash[:message => message, :type => type]
      else
        raise
      end
    end

    def report(type = nil)
      if type
        messages.select { |m| m[:type] == type }.each { |m| puts m[:message] }
      else
        messages.each { |m| puts m[:message] }
      end
    end

  end
end
