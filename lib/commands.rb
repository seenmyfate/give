module Commands
  def git(command)
    `git #{command}`.chomp 
  end

  def sh(command)
    `#{command}`
  end
end
