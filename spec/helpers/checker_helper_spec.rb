require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the CheckerHelper. For example:
#
# describe CheckerHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe CheckerHelper do
  describe "#link_to_cron(statement)" do
    let(:statement) { "0 0 * * * some_report.sh" }

    it "returns a link to the cron check" do
      helper.should_receive(:link_to).with(statement, checker_url(:statement => statement))
      helper.link_to_cron(statement)
    end
  end
end
