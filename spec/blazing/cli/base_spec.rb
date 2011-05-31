require 'spec_helper'
require 'blazing/cli/base'

describe Blazing::CLI::Base do

  before :each do
    @logger = double('logger', :log => nil)
    @base =  Blazing::CLI::Base.new(@logger)
  end

  describe '#init' do
    it 'invokes all CLI::Create tasks' do
      @create_task = double('create task')
      @base.instance_variable_set('@task', @create_task)
      @create_task.should_receive(:invoke_all)
      @base.init
    end
  end

  describe '#setup' do
    it 'says what target is being setup' do
      some_target_name = 'test_target'
      config = Blazing::Config.new
      config.target(some_target_name, :deploy_to => 'smoeone@somewhere:/asdasdasd')
      @base.instance_variable_set("@config", config)
      @base.setup(some_target_name)
    end
  end

  describe '#deploy' do
  end

  describe '#recipes' do
  end

end
