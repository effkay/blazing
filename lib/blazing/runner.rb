require 'erb'
require 'grit'
require 'blazing/config'

# TODO: HANDLE NONEXISTENT TARGET

class Blazing::Runner

  class << self

    def init
      logger.info "Creating an example config file in #{Blazing::DEFAULT_CONFIG_LOCATION}"
      logger.info "Customize it to your needs"

      Dir.mkdir 'config' unless File.exists? 'config'
      configuration_file = ERB.new(File.read("#{Blazing::TEMPLATE_ROOT}/config.erb")).result

      File.open(Blazing::DEFAULT_CONFIG_LOCATION,"wb") do |f|
        f.puts configuration_file
      end
    end

    def setup(target_name, options)
      prepare_config(target_name, options)
      @@targets.each { |t| t.setup }
      update(target, options)
    end

    def update(target_name, options)
      prepare_config(target_name, options)
      setup_git_remotes
      @@targets.each { |t| t.apply_hook }
    end

    def recipes(target_name)
      prepare_config(target_name)
      @@config.recipes.each { |recipe| recipe.run(@targets.options) }
    end

    def list
      Blazing::Recipe.list.each { |r| puts r.to_s.demodulize.underscore }
    end

    def prepare_config(target_name, options = {})
      @@config = Blazing::Config.parse(options[:file])
      @@targets = []
      if target_name == :all
        @@targets << @config.targets
      else
        @@targets << (@@config.targets.find { |t| t.name.to_s == target_name } || @@config.default_target)
      end
    end

    def setup_git_remotes
      repository = Grit::Repo.new(Dir.pwd)
      @@config.targets.each do |target|
        logger.info "Adding new remote #{target.name} pointing to #{target.location}"
        repository.config["remote.#{target.name}.url"] = target.location
      end
    end

  end
end
