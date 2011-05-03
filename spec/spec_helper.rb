begin
  require 'simplecov'
  SimpleCov.start do
     add_filter "/spec/"
  end
rescue LoadError
  puts 'ignoring simplecov, needs ruby-1.9'
end
