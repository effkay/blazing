class Blazing::Target

  attr_accessor :name, :location, :options

  def initialize(name, location, options = {})
    @name = name
    @location = location
    @options = options
  end

end
