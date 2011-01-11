class Create < Thor::Group

  desc 'creates a blazing config file'

  include Thor::Actions

  argument :username
  argument :hostname
  argument :path
  argument :repository

  def self.source_root
    File.dirname(__FILE__)
  end

  def create_blazing_dir
    empty_directory 'deploy'
  end

  def create_config_file
    template('templates/blazing.tt', "deploy/blazing.rb")
  end

end
