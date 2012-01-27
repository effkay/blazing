class Blazing::Shell

  def run(command)
    `#{command}`
  end

end
