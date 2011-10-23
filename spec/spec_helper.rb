require 'blazing'

#
# Stuff borrowed from carlhuda/bundler
#
RSpec.configure do |config|
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

  def destination_root
    File.join(File.dirname(__FILE__), 'sandbox')
  end
end
