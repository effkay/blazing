require 'spec_helper'
require 'blazing'
require 'blazing/cli/create'

describe Blazing::CLI::Create do

  before :each do
    @logger = double('logger', :log => nil, :report => nil)
    @config_generator = Blazing::CLI::Create.new(['repository_url'])
    @config_generator.instance_variable_set('@logger', @logger)
  end

  it 'knows the source root for its tempate' do
    Blazing::CLI::Create.source_root.should == File.dirname(__FILE__).gsub('spec', 'lib')
  end

  it 'creates an empty directory for the config file' do
    @config_generator.should_receive(:empty_directory).with(Blazing::DIRECTORY)
    @config_generator.create_blazing_dir
  end

  it 'creates the config file' do
    @config_generator.should_receive(:template).with('templates/blazing.tt', Blazing::CONFIGURATION_FILE)
    @config_generator.create_config_file
  end

end
