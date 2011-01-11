#
# Stuff that runs on remote machine
#
class Blazing::Remote

  def self.pre_receive(target_name)
    
  end

  def self.post_receive(target_name)
    `rebase --hard HEAD`
  end

end
