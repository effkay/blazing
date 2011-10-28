require 'logging'

include Logging.globally

# here we setup a color scheme called 'bright'
Logging.color_scheme( 'bright',
  :levels => {
    :debug => :green,
    :info  => :green,
    :warn  => :yellow,
    :error => [:white, :on_red],
    :fatal => [:white, :on_red]
  }
)

Logging.appenders.stdout(
  'stdout',
  :layout => Logging.layouts.pattern(
    :pattern => ' ------> [blazing] %-5l: %m\n',
    :color_scheme => 'bright'
  )
)

Logging.logger.root.appenders = 'stdout'
Logging.logger.root.level = :info
Logging.consolidate :root
