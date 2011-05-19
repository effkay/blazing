module Blazing
  class Logger

    LOG_LEVELS =  [:info, :success, :warn, :error]

    def initialize(output = $stdout)
      @output = output
    end

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
        messages.select { |m| m[:type] == type }.each { |m| @output.puts m[:message] }
      else
        messages.each { |m| @output.puts m[:message] }
      end
    end

  end
end
