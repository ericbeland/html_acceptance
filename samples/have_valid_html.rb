require 'html_acceptance'

# This is a sample matcher for use with Rspec and Capybara. 
# https://github.com/jnicklas/capybara 
# keep this in spec/support/matchers

class HaveValidHTML

  # This is the matching method called by RSpec
  # The response is passed in as an argument when you do this:
  # page.should have_valid_html
  
  def matches?(page)
    path  = File.join(File.dirname(__FILE__), '../validation' )
    h     = HTMLAcceptance.new(path)
    @v    = h.validator(page.body, page.current_url)
    @v.valid?
  end
  
  def description
    "Have valid html"
  end

  def failure_message
   "#{@v.resource} Invalid html (fix or run rake html_acceptance task to add exceptions)\n#{@v.resource} exceptions:\n #{@v.exceptions}\n\n #{@v.html}"
  end
  
end
    
def have_valid_html
  HaveValidHTML.new
end
