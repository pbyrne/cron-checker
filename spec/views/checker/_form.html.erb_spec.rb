require 'spec_helper'


describe "checker/_form.html.erb" do
  context "understading the form" do
    before :each do
      render
    end

    it "should include a form" do
      rendered.should have_selector "form[method=get][action$='/check']"
    end

    it "should include a statement field" do
      rendered.should have_selector "form label[for=statement]"
      rendered.should have_selector "form input[type=text][name=statement]"
    end

    it "should have a submit button" do
      rendered.should have_selector "form input[type=submit][value=check]"
    end
  end
end
