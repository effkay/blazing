class Blazing::Runner

  def initialize(config)
    @config = config
  end

  def exec(command)
    raise 'Unknown Command' unless self.respond_to? 'command'
  end

end
