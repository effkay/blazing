require 'blazing'
require 'rspec'
require 'stringio'
require 'pry'
require 'logging'
require 'blazing/logger'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

#
# Stuff borrowed from carlhuda/bundler
#
RSpec.configure do |config|
  config.warnings = false

  #
  # Reset Logger
  #
  Logging.appenders.reset
  Logging.appenders.string_io(
    'string_io',
    layout: Logging.layouts.pattern(
      pattern: ' ------> [blazing] %-5l: %m\n',
      color_scheme: 'bright'
    )
  )

  Logging.logger.root.appenders = 'string_io'

  def capture(*streams)
    streams.map!(&:to_s)
    begin
      result = StringIO.new
      streams.each { |stream| eval "$#{stream} = result" }
      yield
    ensure
      streams.each { |stream| eval("$#{stream} = #{stream.upcase}") }
    end
    result.string
  end

  def setup_sandbox
    @blazing_root = Dir.pwd
    @sandbox_directory = File.join('/tmp/blazing_sandbox')

    # Sometimes, when specs failed, the sandbox would stick around
    FileUtils.rm_rf(@sandbox_directory) if File.exist?(@sandbox_directory)

    # Setup Sandbox and cd into it
    Dir.mkdir(@sandbox_directory)
    Dir.chdir(@sandbox_directory)

    # Setup dummy repository
    Dir.mkdir('repository')
    `git init repository`

    # Setup dummy project
    Dir.mkdir('project')
    `git init project`

    # cd into project
    Dir.chdir('project')
  end

  def teardown_sandbox
    # Teardown Sandbox
    Dir.chdir(@blazing_root)
    FileUtils.rm_rf(@sandbox_directory)
  end

  def spec_root
    File.dirname(__FILE__)
  end
end
