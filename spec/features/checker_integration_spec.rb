require "spec_helper"

describe "checking cron syntax" do
  let(:command) { "./foo" }
  let(:valid_statement) { "0 0 * * * #{command}" }
  let(:invalid_statement) { "asdfasdfasdf" }

  it "explains the given cron statement" do
    visit root_path
    submit_cron_statement valid_statement
    expect_cron_explaination
  end

  it "gracefully handles invalid cron sytnax" do
    visit root_path
    submit_cron_statement invalid_statement
    expect_invalid_cron_statement
  end

  it "gracefully handles a missing cron statement" do
    visit root_path
    submit_cron_statement ""
    expect_missing_cron_statement
  end

  def submit_cron_statement(statement)
    fill_in "statement", with: statement
    click_button "Submit"
  end

  def expect_cron_explaination
    expect(page).to have_content("The command <pre>#{command}</pre> will execute")
    expect(page).to have_content("at 12:00am on every day of the month")
  end

  def expect_invalid_cron_statement
    pending
  end

  def expect_missing_cron_statement
    pending
  end
end
