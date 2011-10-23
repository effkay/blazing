module Blazing::Command
  module Init

    def init_command
      info("Creating an example config file in #{Blazing::DEFAULT_CONFIG_LOCATION}")
      info("Customize it to your needs")

      Dir.mkdir 'config' unless Dir.exists? 'config'
      configuration_file = ERB.new(File.read("#{Blazing::TEMPLATE_ROOT}/config.erb")).result

      File.open(Blazing::DEFAULT_CONFIG_LOCATION,"wb") do |f|
        f.puts configuration_file
      end
    end

  end
end
