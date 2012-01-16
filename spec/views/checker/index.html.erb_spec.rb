require 'spec_helper'

describe "checker/index.html.erb" do
  before :each do
    render
  end

  it "should contain an intro to the application" do
    rendered.should have_selector 'p.intro'
  end

  it "should contain examples" do
    rendered.should have_selector 'div.exmp'
    rendered.should have_selector 'div.exmp h2'
    rendered.should have_selector 'div.exmp a[href*=check]'
  end
end
