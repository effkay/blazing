class Object

  # Borrowed from rails
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

end
