
desc 'Accept HTML validation exceptions results'
task :html_acceptance, :data_path do  |t, args|
  
  HTMLAcceptance.new(args.data_path).each_exception do |result|
      $stdout.puts "Validation Exceptions for #{result.resource}:\n#{result.exceptions}" 
      $stdout.puts "Accept (y)es or (n)o"
      sin=$stdin.gets
      result.accept! if sin.first.downcase == 'y'
      exit if sin.downcase == 'exit' 
    end

end


