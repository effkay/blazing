require 'spec_helper'

  describe 'blazing update' do

    before :each do
      setup_sandbox
      @config = Blazing::Config.new
      @config.target :production, "#{@sandbox_directory}/target"
      @cli = Blazing::CLI.new
      Blazing::Config.stub(:parse).and_return @config
      @output = capture(:stdout, :stderr) { @cli.setup(:production) }
    end

    after :each do
      teardown_sandbox
    end

   it 'generates a post-receive hook based on the current blazing config' do
     File.exists?("/tmp/post-receive").should be true
   end

   it 'copies the generated post-receive hook to the target' do
     File.exists?("#{@sandbox_directory}/target/.git/hooks/post-receive").should be true
   end

 end

