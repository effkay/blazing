#
# Stuff that runs on remote machine
#
class Blazing::Remote

  def self.pre_receive
    
  end

  def self.post_receive
    `rebase --hard HEAD`
  end

end
