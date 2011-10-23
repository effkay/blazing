module Blazing::Command
  module Setup

    def setup_local_command
      repository = Grit::Repo.new(Dir.pwd)
      @config.targets.each do |target|
        info("Adding new remote #{target.name} pointing to #{target.location}")
        repository.config["remote.#{target.name}.url"] = target.location
      end
    end

    def setup_remote_command
      hook = ERB.new(File.read("#{Blazing::TEMPLATE_ROOT}/hook.erb")).result

      File.open('/tmp/post-receive',"wb") do |f|
        f.puts hook
      end


      # clone repo
      # copy hook
      # make hook executable
      # setup denycurrentbranchstuff
    end

  end
end
