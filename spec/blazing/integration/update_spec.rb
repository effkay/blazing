require 'spec_helper'

  describe 'blazing update' do

    before :each do
      setup_sandbox
      @config = Blazing::Config.new
      @config.target :production, "#{@sandbox_directory}/target"
      @config.target :staging, "#{@sandbox_directory}/staging"
      @cli = Blazing::CLI.new
      Blazing::Config.stub(:parse).and_return @config
    end

    after :each do
      teardown_sandbox
    end


   context 'when a target is specified' do

     before :each do
       capture(:stdout, :stderr) { @cli.setup(:production) }
       capture(:stdout, :stderr) { @cli.update(:production) }
     end

     it 'generates a post-receive hook based on the current blazing config' do
       File.exists?("/tmp/post-receive").should be true
     end

     it 'copies the generated post-receive hook to the target' do
       File.exists?("#{@sandbox_directory}/target/.git/hooks/post-receive").should be true
     end
   end

   context 'when all is specified as target' do
     it 'updates all targets' do
       capture(:stdout, :stderr) { @cli.setup('all') }
       capture(:stdout, :stderr) { @cli.update('all') }
       File.exists?("#{@sandbox_directory}/target/.git/hooks/post-receive").should be true
       File.exists?("#{@sandbox_directory}/staging/.git/hooks/post-receive").should be true
     end
   end

 end

