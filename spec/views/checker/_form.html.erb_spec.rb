require 'spec_helper'


describe "checker/_form.html.erb" do
  before :each do
    params[:statement] = 'foo'
    render
  end

  it "should include a form" do
    rendered.should have_selector "form[method=get][action$='/check']"
  end

  it "should include a statement field" do
    rendered.should have_selector "form label[for=statement]"
    rendered.should have_selector "form input[type=text][name=statement]"
  end

  it "should populated the statement field with the value of the 'statement' parameter" do
    rendered.should have_selector "form input[name=statement][value='foo']"
  end

  it "should have a submit button" do
    rendered.should have_selector "form input[type=submit][value=Check]"
  end
end
