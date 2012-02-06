require 'blazing/shell'
require 'grit'

class Blazing::Target

  include Blazing::Logger

  attr_accessor :name, :location, :options

  def initialize(name, location, config, options = {})
    @name = name
    @location = location
    @config = config
    @options = options
    @shell = Blazing::Shell.new
    @target = self
  end

  def setup
    info "Setting up repository for #{name} in #{location}"

    # TODO: Handle case where user is empty
    if host
      @shell.run "ssh #{user}@#{host} '#{init_repository} && #{setup_repository}'"
    else
      @shell.run "#{init_repository} && #{setup_repository}"
    end
  end

  def apply_hook
    info "Generating and uploading post-receive hook for #{name}"
    hook = ERB.new(File.read("#{Blazing::TEMPLATE_ROOT}/hook.erb")).result(binding)

    File.open(Blazing::TMP_HOOK, "wb") do |f|
      f.puts hook
    end

    debug "Copying hook for #{name} to #{location}"
    copy_hook
    if host
      @shell.run "ssh #{user}@#{host} #{make_hook_executable}"
    else
      @shell.run "#{make_hook_executable}"
    end
  end

  def setup_git_remote
    repository = Grit::Repo.new(Dir.pwd)
    info "Adding new remote #{name} pointing to #{location}"
    repository.config["remote.#{name}.url"] = location
  end

  def path
    if host
      @location.match(/:(.*)$/)[1]
    else
      @location
    end
  end

  def host
    host = @location.match(/@(.*):/)
    host[1] unless host.nil?
  end

  def user
    user = @location.match(/(.*)@/)
    user[1] unless user.nil?
  end

  #
  # Initialize an empty repository, so we can push to it
  #
  def init_repository
    # Instead of git init with a path, so it does not fail on older
    # git versions (https://github.com/effkay/blazing/issues/53)
    "mkdir #{path}; cd #{path} && git init"
  end

  def copy_hook
    debug "Making hook executable"
    # TODO: handle missing user?
    if host
      @shell.run "scp #{Blazing::TMP_HOOK} #{user}@#{host}:#{path}/.git/hooks/post-receive"
    else
      @shell.run "cp #{Blazing::TMP_HOOK} #{path}/.git/hooks/post-receive"
    end
  end

  def make_hook_executable
    debug "Making hook executable"
    "chmod +x #{path}/.git/hooks/post-receive"
  end

  def setup_repository
    "cd #{path} && git config receive.denyCurrentBranch ignore"
  end

  def rake_command
    rake_config = @config.instance_variable_get("@rake") || {}
    rails_env = "RAILS_ENV=#{@options[:rails_env]}" if @options[:rails_env]
    "#{rake_config[:env]} #{rails_env} bundle exec rake #{rake_config[:task]}"
  end

end
