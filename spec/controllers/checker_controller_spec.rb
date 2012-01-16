require 'spec_helper'

describe CheckerController do
  describe "GET 'index'" do
    before :each do
      get 'index'
    end

    it "returns http success" do
      response.should be_success
    end
  end

  describe "GET 'check'" do
    let!(:params) { { :statement => 'foo' } }
    let!(:cron) { mock(Cron) }

    context "with a statement" do
      before :each do
        Cron.should_receive(:new).with(params[:statement]).and_return(cron)
        get 'check', params
      end

      it "returns http success" do
        response.should be_success
      end

      it "generates a new cron job from the provided statement" do
        assigns(:cron).should == cron
      end
    end

    context "without a statement" do
      before :each do
        get 'check'
      end

      it "redirects to the home page" do
        response.should redirect_to(root_url)
      end
    end
  end

end
