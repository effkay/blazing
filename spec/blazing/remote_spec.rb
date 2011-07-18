# require 'spec_helper'
# require 'blazing/remote'

# describe Blazing::Remote do

#   before :each do
#     # recipes = []
#     # @config = double('config', :load => double('actual_config', :recipes => recipes, :find_target => double('target', :recipes => recipes)))
#     @config = Blazing::Config.new
#     @config.target :some_name, :deploy_to => 'user@hostname:/path'
#     @remote = Blazing::Remote.new('some_name', :config => @config)
#     @remote.instance_variable_set('@_dir', double('Dir', :chdir => nil))
#   end

#   describe '#post_receive' do
#     before :each do
#       @remote.instance_variable_set('@runner', double('runner', :run => true))
#       Dir.stub!(:chdir)
#     end

#     it 'sets up the git dir' do
#       @remote.should_receive(:set_git_dir)
#       @remote.post_receive
#     end

#     it 'runs the recipes' do
#       @remote.should_receive(:run_recipes)
#       @remote.post_receive
#     end

#     it 'resets the git repository' do
#       @remote.should_receive(:reset_head!)
#       @remote.post_receive
#     end
#   end

#   describe '#gemfile_present?' do
#     it 'checks if a Gemfile is in the cwd' do
#       File.should_receive(:exists?).with('Gemfile')
#       @remote.gemfile_present?
#     end
#   end

#   describe '#set_git_dir' do
#     it 'sets .git as gitdir if git dir is "."' do
#       # Dir.should_receive(:chdir).with('.git')
#       # @remote.set_git_dir
#     end
#   end

#   describe '#reset_head!' do
#     it 'does a git reset --hard HEAD' do
#       runner = double('runner', :run => nil)
#       @remote.instance_variable_set('@runner', runner)
#       runner.should_receive(:run).with('git reset --hard HEAD')
#       @remote.reset_head!
#     end
#   end

#   describe '#use_rvm?' do
#     context 'with rvm recipe enabled' do
#       it 'returns the rvm string' do
#         @remote.instance_variable_set('@recipes', double('recipes', :find => double('recipe', :options => { :rvm_string => 'someruby@somegemset'}), :delete_if => nil))
#         @remote.use_rvm?.should == 'someruby@somegemset'
#       end

#       it 'deletes the rvm recipes from the recipes array' do
#         @remote.instance_variable_set('@recipes', [double('rvm_recipe', :name => 'rvm', :options => {})])
#         @remote.use_rvm?
#         @remote.instance_variable_get('@recipes').should be_blank
#       end
#     end

#     context 'without rvm_recipe' do
#       it 'returns false' do
#         @remote.instance_variable_set('@recipes', double('rvm_recipe', :find => false, :delete_if => nil))
#         @remote.use_rvm?.should be false
#       end
#     end
#   end

#   describe '#setup_recipes' do
#     context 'when the target has no recipes' do
#       it 'assigns the global recipes settings from the config' do
#         recipe_probe = double('recipe_probe', :name => 'noname', :run => nil)
#         config = double('config', :recipes => [recipe_probe])
#         @remote.instance_variable_set('@config', config)
#         @remote.setup_recipes
#         @remote.instance_variable_get('@recipes').first.should be recipe_probe
#       end
#     end

#     context 'when the target has recipes' do
#       it 'does not touch the target recipes' do
#         target_recipe_probe = double('target_recipe_probe', :name => 'target', :run => nil)
#         global_recipe_probe = double('global_recipe_probe', :name => 'global', :run => nil)
#         global_config = double('config', :recipes => [global_recipe_probe])
#         blazing_config_class = double('blazing_config', :parse => global_config)
#         @remote.instance_variable_set('@_config', blazing_config_class)
#         @remote.instance_variable_set('@recipes', [target_recipe_probe])
#         @remote.setup_recipes
#         @remote.instance_variable_get('@recipes').first.name.should == 'target'
#       end
#     end
#   end

#   describe '#run_recipes' do
#     it 'runs all recipes' do
#       recipes =  [double('one', :name => nil), double('two', :name => nil), double('three', :name => nil)]
#       @remote.instance_variable_set('@recipes', recipes)
#       recipes.each do |recipe|
#         recipe.should_receive(:run)
#       end
#       @remote.run_recipes
#     end
#   end

#   describe '#run_bootstrap_recipes' do

#     before :each do
#       @bundler = double('bundler', :name => 'bundler', :run => nil)
#       @recipes =  [@bundler, double('two', :name => nil), double('three', :name => nil)]
#       @remote.instance_variable_set('@recipes', @recipes)
#     end

#     it 'runs bundler recipe if it is enabled' do
#       @bundler.should_receive(:run)
#       @remote.run_bootstrap_recipes
#     end

#     it 'deletes the bundler recipe from the array after running it' do
#       @remote.run_bootstrap_recipes
#       @recipes.find { |r| r.name == 'bundler' }.should be nil
#     end
#   end
# end
