require 'blazing/config'

class Blazing::CLI < Thor

  # TODO: optional project directory
  desc 'init', 'initialize blazing in project'
  def init
    username = ask "Deploy User: "
    hostname = ask "Target hostname: "
    path = ask "Deploy path on server: "
    repository = ask "Enter is this projects repository: "
    invoke 'blazing:config:create', [username, hostname, path, repository]
  end


  desc 'setup TARGET', 'bootstrap or update blazing setup on remote host and do a first deploy'
  def setup(target = nil)
  
    # Load config file
    config = Blazing::Config.read do |blazing|
      blazing.instance_eval(File.read blazing.file)
    end

    # Check if target can be found in config file
    if target
      target = config.targets.find { |t| t.name == target.to_sym }
    end

    target = target || config.determine_target

    if target
      say "[BLAZING] -- SETTING UP #{ target.location }", :yellow
      invoke 'blazing:target:setup:setup_repository', [target]
    else
      say 'no target specified and no default found in config', :red
    end
    
  end

  desc 'deploy TARGET', 'deploy project with blazing'
  def deploy
    # TODO: check if deployed setup is still uptodate, if not, run setup
    # tag and push
  end

end
