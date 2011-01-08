require 'blazing/config'

class Blazing::CLI < Thor

  #TODO: optional project directory
  desc 'init', 'initialize blazing in project'
  def init
    username = ask "Deploy User: "
    hostname = ask "Target hostname: "
    path = ask "Deploy path on server: "
    invoke 'blazing:config:create', [username, hostname, path]
  end


  desc 'setup TARGET', 'bootstrap or update blazing setup on remote host and do a first deploy'
  def setup(target = nil)
  
    # Load config file
    config = Blazing::Config.read do |blazing|
      blazing.instance_eval(File.read blazing.file)
    end
    p config.targets

    #if target.nil?

      # check if there is a default target
      # - by checking if there is a target in global
      # - or there is a default_target in global 
      # => assign if present, else ask:
      
    # target = target || ask("Deployment Target: ") 

    #Blazing::Remote.clone
    #Blazing::Remote.add_pre_receive_hook
    #Blazing::Remote.add_post_receive_hook
    
  end

  desc 'deploy TARGET', 'deploy project with blazing'
  def deploy
    # TODO: check if deployed setup is still uptodate, if not, run setup
    # tag and push
  end

end
