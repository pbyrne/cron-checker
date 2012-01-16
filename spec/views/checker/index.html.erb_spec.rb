require 'spec_helper'

describe "checker/index.html.erb" do
  before :each do
    render
  end

  it "should contain an intro to the application" do
    rendered.should have_selector 'p.intro'
  end
end
