class Blazing::CLI < Thor

  desc 'setup TARGET', 'bootstrap blazing setup and do a first deploy'
  def setup(stage = 'default')
    
    # First time setup ?
    if File.exists?('deploy/blazing.rb')
      if yes? 'do you want to overwrite your current blazing configuration?', 'red'
        say 'overwriting existing configuration'
        install_from_scratch = true
      end
    else
      install_from_scratch = true
    end

    if install_from_scratch
      say 'bootstraping configuration'
      Blazing::Config.create
    end
    
    # add pre-receive hook
    # add post-receive hook
  end

  desc 'deploy TARGET', 'deploy project with blazing'
  def deploy
    # check if deployed setup is still uptodate, if not, run setup
    # tag and push
  end

end
