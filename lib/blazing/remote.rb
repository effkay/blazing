#
# Stuff that runs on remote machine
#
class Blazing::Remote

  def self.pre_receive(target_name)
    # really needed? probably only for maintenance page, maybe even this can be done post receive
  end

  def self.post_receive(target_name)
    
    target = Blazing::Config::Helper.find_target(target_name)

    `git reset --hard HEAD`

    `bundle update`
  end

end
