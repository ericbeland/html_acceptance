require 'rake'
require 'html_acceptance'

desc 'Accept HTML validation exceptions results'
task :html_acceptance do

  unless ENV.include?("DATA_PATH")
    raise "usage: rake html_acceptance DATA_PATH=foo" 
  end
  
  HTMLAcceptance.new(env['DATA_PATH']).each_exception do |result|
      $stdout.puts "Validation Exceptions:\n #{result}" 
      $stdout.puts "Accept (y)es or (n)o"
      sin=$stdin.gets
      result.accept! if sin.first == 'y'
      exit if sin == 'exit' 
  end

end


