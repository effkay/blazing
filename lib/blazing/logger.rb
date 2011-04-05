module Blazing
  class Logger

    LOG_LEVELS =  [:info, :success, :warn, :error]

    def initialize(use_color = false)
      @use_color = use_color
    end

    def messages
      @messages ||= []
    end

    def puts(message, type)
      messages << Hash[:message => message, :type => type]
    end

    LOG_LEVELS.each do |type|
      define_method type do |message|
        puts(message, type)
      end
    end

    # def prefix
    #   '[BLAZING] *** '
    # end

    # def postfix
    #   ' ***'
    # end

    # def message(message, type)
    #   case type
    #   when :info
    #     puts prefix + message.blue + postfix
    #   when :success
    #     puts prefix + message.green + postfix
    #   when :warn
    #     puts prefix + message.yellow + postfix
    #   when :error
    #     puts prefix + message.red + postfix
    #   end
    # end

  end
end

class String

# 00  Turn off all attributes
# 01  Set bright mode
# 04  Set underline mode
# 05  Set blink mode
# 07  Exchange foreground and background colors
# 08  Hide text (foreground color would be the same as background)
# 30  Black text
# 31  Red text
# 32  Green text
# 33  Yellow text
# 34  Blue text
# 35  Magenta text
# 36  Cyan text
# 37  White text
# 39  Default text color
# 40  Black background
# 41  Red background
# 42  Green background
# 43  Yellow background
# 44  Blue background
# 45  Magenta background
# 46  Cyan background
# 47  White background
# 49  Default background col

 def black
   string = "\033[30m"
   string << self
   string << "\033[0m"
 end

 def red
   string = "\033[31m"
   string << self
   string << "\033[0m"
 end

 def green
   string = "\033[32m"
   string << self
   string << "\033[0m"
 end

 def yellow
   string = "\033[33m"
   string << self
   string << "\033[0m"
 end

 def blue
   string = "\033[34m"
   string << self
   string << "\033[0m"
 end

 def purple
   string = "\033[35m"
   string << self
   string << "\033[0m"
 end

 def cyan
   string = "\033[36m"
   string << self
   string << "\033[0m"
 end

 def white
   string = "\033[37m"
   string << self
   string << "\033[0m"
 end

end

