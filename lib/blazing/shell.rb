module Blazing
  class Shell
    def run(command)
      `#{command}`
    end
  end
end
