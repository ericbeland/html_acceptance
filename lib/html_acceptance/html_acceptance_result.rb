require 'open3'

class HTMLAcceptanceResult
  attr_accessor :resource, :html, :exceptions
  
  def initialize(resource, html, datapath, options={})
    @resource = resource
    @html = html
    @exceptions = ''
    @datapath=datapath
    @tidyopts = options[:tidy_opts] || "-qi"
    valid?
  end

  # takes a .url.txt and loads the data into this object
  def self.load_from_files(datapath)
    resource = File.open("#{datapath}.resource.txt", 'r').read
    html = File.open("#{datapath}.html.txt", 'r').read
	  HTMLAcceptanceResult.new(resource, html, datapath)
  end
  
  # Validates an html string using html tidy. If there are no warnings or exceptions, or 
  # there is a previously accepted exception string that matches exactly, valid? returns true
  # Line numbers of exceptions are likely to change with any edit, so our validation 
  # compares the exception strings with the lines and columns removed. Name can be a filename,
  # file system path, or url, so long it is uniquely associated with the passed in html.
  def valid?
    @exceptions = validate 
    File.delete(data_path("accepted.txt")) if File.exists?(data_path("accepted.txt")) if @exceptions == '' 
    valid=(@exceptions == '' or accepted?(@exceptions))
    save_html_and_exceptions
    valid
  end
  

  # Saves the exception string for the given url or file path. When next run, if the exception
  # string is identical, valid? will return true. Note that #exceptions will still list the 
  # exception string, though, even if it is an accepted exception string.
  def accept!    
    File.open(data_path("accepted.txt"), 'w') {|f| f.write(@exceptions) }
  end
  
  private
    # We specifically prefer /usr/bin/tidyby default on *nix as there is another "tidy" programs
  # that could end up earlier on the path.  On snow leopard, tidy was installed at this location 
  # for me by default.
  def tidy_command
    is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
    bin=(is_windows or !File.exists?("/usr/bin/tidy")) ? 'tidy' : '/usr/bin/tidy'
    "#{bin} #{@tidyopts}"
  end
    
  # get the filename for storing a type of data
  def data_path(filetype)
    "#{@datapath}.#{filetype}"
  end

  def save_html_and_exceptions
    File.open(data_path("exceptions.txt"), 'w') {|f| f.write(@exceptions) }      
    File.open(data_path("html.txt"), 'w') {|f| f.write(@html) }
    File.open(data_path("resource.txt"), 'w') {|f| f.write(@resource) }    
  end      

    # have we previously accepted this exact string for this path?
  def accepted?(exception_str)
    exception_str=filter(exception_str)
    File.exists?(data_path('accepted.txt')) ? filter(File.open(data_path('accepted.txt'),"r").read) == exception_str : false
  end
  
  # Line numbers of exceptions are likely to change with any minor edit, so our validation 
  # compares the result strings with the lines and columns removed. This means that 
  # if the errors change position in the file (up or down b/c you add or remove code), 
  # accepted exception strings will remain valid.
  def filter(str)
	str.gsub!(/line [0-9]+ column [0-9]+ - Warning: trimming empty <[a-zA-Z]+>/, '')  # the messages about empty are overzealous, and not invalid
    str.gsub(/line [0-9]+ column [0-9]+ -/, '')	
   # /line [0-9]+ column [0-9]+ - / +  =~ "line 1 column 1 - Warning: missing <!DOCTYPE> declaration"
  end
      
  def validate
    stdin, stdout, stderr = Open3.popen3(tidy_command)
    stdin.puts @html
    stdin.close
    result=stderr.read
  end
  
end
