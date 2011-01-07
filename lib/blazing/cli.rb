class Blazing::CLI < Thor

  desc 'setup TARGET', 'bootstrap blazing setup and do a first deploy'
  def setup
    Blazing::CLI.setup
    # add local configdir and config with defaults and selected options
    # add pre-receive hook
    # add post-receive hook
  end

  desc 'deploy TARGET', 'deploy project with blazing'
  def deploy
    Blazing::CLI.deploy
    # tag and push
  end

end

Blazing.start
