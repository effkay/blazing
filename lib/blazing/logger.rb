require 'logging'

module Blazing
  module Logger
    # include Logging.globally

    # here we setup a color scheme called 'bright'
    Logging.color_scheme('bright',
                         levels: {
                           debug: :green,
                           info: :green,
                           warn: :yellow,
                           error: [:white, :on_red],
                           fatal: [:white, :on_red]
                         }
                        )

    Logging.appenders.stdout(
      'stdout',
      layout: Logging.layouts.pattern(
        pattern: ' ------> [blazing] %-5l: %m\n',
        color_scheme: 'bright'
      )
    )

    Logging.logger.root.appenders = 'stdout'
    Logging.logger.root.level = :info

    %w(debug info warn error fatal).each do |level|
      define_method level do |message|
        Logging.logger[self].send(level, message)
      end
    end
  end
end
