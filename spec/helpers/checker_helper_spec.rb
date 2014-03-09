require "spec_helper"

describe CheckerHelper do
  describe "#link_to_cron(statement)" do
    let(:statement) { "0 0 * * * some_report.sh" }

    it "displays the statement and links to its check" do
      expect(helper.link_to_cron(statement)).
        to eq(link_to statement, check_path(statement: statement))
    end
  end
end
