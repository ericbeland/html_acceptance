require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HtmlAcceptance" do
  
  def tmp_path
    is_windows=(RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
    is_windows ? 'c:\temp\validation' : '/tmp/validation'
  end
  
  before(:each) do
    FileUtils.mkdir '/tmp/validation'  if !File.exists?('/tmp/validation')
    @h=HTMLAcceptance.new('/tmp/validation')    
  end
  
  it "should return false for invalid xml" do
    result=@h.validator(bad_html, "http://myothersite.com").valid?.should be_false
  end
  
  it "should return true for valid html" do
    result=@h.validator(good_html, "http://mysite.com").valid?.should be_true
  end
  
  it "should have an exception string for invalid xml" do
    result=@h.validator(bad_html, "http://myfavoritesite.com")
    (result.exceptions.empty?).should be_false
  end
  
  it "should return true for valid? if exceptions are accepted" do
    result=@h.validator(bad_html, "http://mynewsite.com")
    result.accept!
    result=@h.validator(bad_html, "http://mynewsite.com").valid?.should be_true
  end
  
  it "should show no exceptions for a truly valid file" do
    result=@h.validator(good_html, "http://mybestsite.com")
    (result.exceptions == '').should be_true
  end
  
  it "should still show exceptions when returning valid for an accepted exception string" do
    result=@h.validator(bad_html, "http://myworstsite.com")
    result.accept!
    result=@h.validator(bad_html, "http://myworstsite.com")
    result.valid?.should be_true
    (result.exceptions.length == 0).should be_false
  end
  
  it "should reset exceptions after each call to valid?" do
    result=@h.validator(bad_html, "http://myuglysite.com")
    result=@h.validator(good_html, "http://myuglysite.com")
    (result.exceptions.length == 0).should be_true
    result.valid?.should be_true
  end
  
  it "should reset accepted exceptions string after seeing valid html for a path" do
    result=@h.validator(bad_html, "http://notmysite.com")
    result.accept!
    result=@h.validator(bad_html, "http://notmysite.com").valid?.should be_true
    # now we see valid, so we should reset
    result=@h.validator(good_html, "http://notmysite.com").valid?.should be_true
    result=@h.validator(bad_html, "http://notmysite.com").valid?.should be_false
  end
  
  it "should not pass different exception" do
    result=@h.validator(bad_html, "http://mycoolsite.com")
    result.accept!
    e1=result.exceptions
    result=@h.validator("<html></body></html>", "http://mycoolsite.com").valid?.should be_false    
  end
  
  it "should let me pass a tidy option" do
    @h=HTMLAcceptance.new('/tmp/validation', :tidy_opts=>"-e")
    result=@h.validator("<html>foo", 'c:\mycoolapp\somesite.html')
    result.exceptions.include?("were found!").should be_true
    @h=HTMLAcceptance.new('/tmp/validation')
    result=@h.validator("<html>foo", 'c:\mycoolapp\somesite.html')
    result.exceptions.include?("were found!").should be_false  
  end
  
  private
  
  def bad_html
    '<html><title>the title<title></head><body><p>blah blah</body></html>'
  end
  
  def good_html
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><title>the title</title></head><body><p>a paragraph</body></html>'
  end
  
end
