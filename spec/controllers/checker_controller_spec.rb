require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CheckerController do

  #Delete these examples and add some real ones
  it "should use CheckerController" do
    controller.should be_an_instance_of(CheckerController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'check'" do
    it "should be successful" do
      get 'check'
      response.should be_success
    end
  end
end
