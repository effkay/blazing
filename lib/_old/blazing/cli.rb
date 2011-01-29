require 'blazing/config'
require 'blazing/config/helper'

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
    
    target = Blazing::Config::Helper.find_target(target)

    if target
      say "[BLAZING] -- SETTING UP #{ target.location }", :yellow
      invoke 'blazing:remote:setup:setup_repository', [target]
    else
      say 'no remote specified and no default found in config', :red
    end
    
  end

  desc 'deploy TARGET', 'deploy project with blazing'
  def deploy(target=nil)
    
    target = Blazing::Config::Helper.find_target(target)
    
    # TODO: optional: specify branch
    `git push #{ target.name } master`

    # TODO: check if deployed setup is still uptodate, if not, run setup
    # tag and push
  end

end
