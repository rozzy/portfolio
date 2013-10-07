  #!/usr/bin/env ruby

  require File.expand_path(File.dirname(__FILE__) + '/Blog.rb')
  require 'vegas'

  Vegas::Runner.new(Blog, 'Blog')