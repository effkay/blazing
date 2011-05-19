module Blazing
  module Logger

    LOG_LEVELS =  [:info, :success, :warn, :error]

    def messages
      @messages ||= []
    end

    def log(message, type)
      messages << Hash[:message => message, :type => type]
    end

  end
end
