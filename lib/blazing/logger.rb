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

  end
end
