
desc 'Accept HTML validation exceptions results'
task :html_accept, :data_path do  |t, args|
  
  HTMLAcceptance.new(args.data_path).each_exception do |result|
      $stdout.puts "Validation Exceptions:\n #{result.exceptions}" 
      $stdout.puts "Accept (y)es or (n)o"
      sin=$stdin.gets
      result.accept! if sin.first == 'y'
      exit if sin == 'exit' 
  end

end
