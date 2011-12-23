module Commands
  def git(command)
    `git #{command}`   
  end

  def sh(command)
    `#{command}`
  end
end
