require 'spec_helper'

describe "checker/check.html.erb" do
  let(:cron) { Cron.new('0 0 * * * some_report.sh') }

  before :each do
    assign(:cron, cron)
    render
  end

  it "contains the checker form" do
    rendered.should render_template('form')
  end

  it "displays the plain-English output of the cron statement" do
    rendered.should have_content(cron.to_s)
  end
end
