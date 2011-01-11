class Blazing::Target

  attr_accessor :name, :user, :hostname, :path, :recipes, :target_name, :default_target, :repository

  def initialize(name, repository, &block)
    @name = name
    @repository = repository
    instance_eval &block
  end

  def deploy_to(location)
    @user = location.match('(.*)@')[1]
    @hostname = location.match('@(.*):')[1]
    @path = location.match(':(.*)')[1]
  end

  def location
    # TODO: build this together more carefully, checking for emtpy hostname etc...
    @location ||= "#{ @user }@#{ @hostname }:#{ @path }"
  end

  # Only used in global target for setting default target
  # TODO: extract into other class, inherit
  def set_default_target(target_name)
    @default_target = target_name
  end

end
