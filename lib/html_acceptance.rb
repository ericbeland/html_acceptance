# == HTML Acceptance
# HTLM Acceptance helps you watch and come to terms with your HTML's validity, or lack thereof.  
# The idea is to take an html markup string associated with a particular path (file or URL),
# and validate it. It is intended to be used in acceptance tests, test suites or a rake task
# to alert you to changes in your html's validity so you can fix them, or barring that, review and accept
# errors and warnings. 

# ==Resource paths
# When calling the validation routine, a path, or URL is passed. This is used internally to name 
# the resulting validation output files.

# NOTE: HTMLAcceptance never retreives html or reads in files *for* you. It doesn't read files, or call 
# passed URL's. The purpose of passing a resource path is to give the test a name which saved exceptions 
# can be stored against and compared to. In theory, the resource could be any distinct string, meaningful or not.

# If the resource (URL or file) has a saved exception string and it matches, the validation passes. 
# The user can use a rake task can run this manually and upd  ate the accepted exception string.

require 'rbconfig'
require 'html_acceptance/html_acceptance_result'

class HTMLAcceptance
  
  
  # The data_folder is where we store our output. options[:tidyopts], which defaults to "-qi"
  # can be used to override the command line options to html tidy.  On *nix, man tidy to see
  # what else you might use for this string instead of "-qi", however "-qi" is probably what 
  # you want 95% of the time.
  
  # You may also pass :ignore_proprietary=>true as an option to suppress messages like: 
  #  line 1 column 176 - Warning: <textarea> proprietary attribute "wrap"
  #  line 1 column 176 - Warning: <textarea> proprietary attribute "spellcheck"
  
  # It may be useful to pass a subfolder in your project as the data_folder, so your
  # html acceptance status and validation results are stored along with your source. 
  def initialize(data_folder, options={})
    @data_folder = data_folder
    @options = options
  end

  # For each stored exception, yield an HTMLAcceptanceResult object to allow the user to 
  # call .accept! on the exception if it is OK.  
  def each_exception
    Dir.chdir(@data_folder)
    Dir.glob("*.exceptions.txt").each do |file|
      if File.open(file, 'r').read != ''
        yield HTMLAcceptanceResult.load_from_files(file.gsub('.exceptions.txt',''))
      end
    end
  end
  
  def validator(html, resource)
    datapath=File.join(@data_folder, filenameize(resource))
    HTMLAcceptanceResult.new(resource, html, datapath, @options)
  end
  
  private
  
  # take a url or filepath, trim and sanitize it for use as a filename
  def filenameize(path)
    path.gsub!(/www.|^(http:\/\/|\/|C:\\)/, '')
    path.gsub(/[^0-9A-Za-z.]/,'_')  
  end

  
end
