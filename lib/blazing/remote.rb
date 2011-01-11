#
# Stuff that runs on remote machine
#
class Blazing::Remote

  def pre_receive
    
  end

  def post_receive
    `rebase --hard HEAD`
  end

end