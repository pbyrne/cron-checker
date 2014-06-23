require "rails_helper"

describe ApplicationHelper do
  context "#copyright(year)" do
    let(:current_year) { Date.today.year }
    let(:prior_year) { current_year - 1 }

    it "includes an abbreviation for the copyright symbol" do
      expect(helper.copyright(current_year)).to include(%{<abbr title="copyright">©</abbr>})
    end

    it "marks up a copyright notice for the given year" do
      expect(helper.copyright(current_year)).to match(/#{current_year}\z/)
    end

    it "marks up a copyright notice range for past years" do
      expect(helper.copyright(prior_year)).to match(/#{prior_year}–#{current_year}\z/)
    end
  end
end
