require 'blazing/shell'

class Blazing::Target

  attr_accessor :name, :location, :options

  def initialize(name, location, config, options = {})
    @name = name
    @location = location
    @config = config
    @options = options
    @shell = Blazing::Shell.new
  end

  def setup
    @shell.run "ssh #{user}@#{host} '#{clone_repository} && #{setup_repository}'"
    self.update
  end

  def update
    hook = ERB.new(File.read("#{Blazing::TEMPLATE_ROOT}/hook.erb")).result

    File.open(Blazing::TMP_HOOK, "wb") do |f|
      f.puts hook
    end

    copy_hook
    @shell.run "ssh #{user}@#{host} #{make_hook_executable}"
  end

  def path
    @location.match(/:(.*)$/)[1]
  end

  def host
    host = @location.match(/@(.*):/)
    host[1] unless host.nil?
  end

  def user
    user = @location.match(/(.*)@/)
    user[1] unless user.nil?
  end

  def clone_repository
    "git clone #{@config.repository} #{path}"
  end

  def copy_hook
    @shell.run "scp #{Blazing::TMP_HOOK} #{user}@#{host}:#{path}/.git/hooks/post-receive"
  end

  def make_hook_executable
    "chmod +x #{path}/.git/hooks/post-receive"
  end

  def setup_repository
    "cd #{path} && git config receive.denyCurrentBranch ignore"
  end

end
