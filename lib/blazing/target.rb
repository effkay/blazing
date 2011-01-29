# TODO: Try to read username/hostname for ssh from git url, else raise error
module Blazing
  class Target

    attr_reader :name

    def initialize(name, &block)
      @name = name
      instance_eval(&block)
    end
  end

  def deploy_to(url)
    if url
      @deploy_to = url
    else
      @deploy_to
    end
  end

end