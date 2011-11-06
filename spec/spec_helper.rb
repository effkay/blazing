require 'blazing'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

#
# Stuff borrowed from carlhuda/bundler
#
RSpec.configure do |config|

  #
  # Reset Logger
  #
  Logging.appenders.reset
  Logging.appenders.string_io(
    'string_io',
    :layout => Logging.layouts.pattern(
      :pattern => ' ------> [blazing] %-5l: %m\n',
      :color_scheme => 'bright'
    )
  )

  Logging.logger.root.appenders = 'string_io'

  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

  def setup_sandbox
    @blazing_root = Dir.pwd
    @sandbox_directory = File.join('/tmp/blazing_sandbox')

    # Sometimes, when specs failed, the sandbox would stick around
    FileUtils.rm_rf(@sandbox_directory) if File.exists?(@sandbox_directory)

    # Setup Sandbox and cd into it
    Dir.mkdir(@sandbox_directory)
    Dir.chdir(@sandbox_directory)
    `git init .`
  end

  def teardown_sandbox
    # Teardown Sandbox
    Dir.chdir(@blazing_root)
    FileUtils.rm_rf(@sandbox_directory)
  end

  def spec_root
    File.dirname(__FILE__)
  end

  def prepare_sample_config
    sample_config = File.join(spec_root, 'support', 'sample_config_1.rb')
    Dir.mkdir(@sandbox_directory + '/config')
    FileUtils.cp(sample_config, @sandbox_directory + '/config/blazing.rb')
  end

end
