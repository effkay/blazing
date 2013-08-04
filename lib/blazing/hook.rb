require 'erb'

module Blazing
  class Hook

    include Blazing::Logger

    attr_accessor :target

    def initialize(target)
      @target = target
      @config = target.config
      @options = target.options
      @shell = Blazing::Shell.new
    end

    def setup
      prepare_hook
      deploy_hook
    end

    def rake_command
      if @config.rake_task
        "#{options_as_vars}bundle exec rake #{@config.rake_task}"
      end
    end

    private

    def options_as_vars
      keys = @options.keys
      options = ""
      keys.each do |key|
        options << "#{key.upcase}=#{@options[key]} "
      end

      options
    end

    def load_template(template_name)
      ::ERB.new(File.read(find_template(template_name))).result(binding)
    end

    def find_template(template_name)
      "#{Blazing::TEMPLATE_ROOT}/#{template_name}.erb"
    end

    def prepare_hook
      info "Generating and uploading post-receive hook for #{@target.name}"
      hook = generate_hook
      write hook
    end

    def deploy_hook
      debug "Copying hook for #{@target.name} to #{@target.location}"
      copy_hook
      set_hook_permissions
    end

    def generate_hook
      load_template 'hook/base'
    end

    def write(hook)
      File.open(Blazing::TMP_HOOK, "wb") do |f|
        f.puts hook
      end
    end

    def set_hook_permissions
      if @target.host
        @shell.run "ssh #{@target.user}@#{@target.host} '#{make_hook_executable}'"
      else
        @shell.run "#{make_hook_executable}"
      end
    end

    def copy_hook
      debug "Making hook executable"
      # TODO: handle missing user?
      if @target.host
        @shell.run "scp #{Blazing::TMP_HOOK} #{@target.user}@#{@target.host}:#{@target.path}/.git/hooks/post-receive"
      else
        @shell.run "cp #{Blazing::TMP_HOOK} #{@target.path}/.git/hooks/post-receive"
      end
    end

    def make_hook_executable
      debug "Making hook executable"
      "chmod +x #{@target.path}/.git/hooks/post-receive"
    end
  end
end

