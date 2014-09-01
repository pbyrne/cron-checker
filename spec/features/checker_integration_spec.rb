require "rails_helper"

describe "checking cron syntax" do
  let(:command) { "./foo" }
  let(:valid_statement) { "0 0 * * * #{command}" }
  let(:invalid_statement) { "asdfasdfasdf" }

  it "explains the given cron statement" do
    submit_cron_statement valid_statement
    expect_cron_explaination
    expect_filled_form_field valid_statement
  end

  it "gracefully handles invalid cron sytnax" do
    submit_cron_statement invalid_statement
    expect_invalid_cron_statement
    expect_filled_form_field invalid_statement
  end

  it "gracefully handles a missing cron statement" do
    submit_cron_statement ""
    expect_missing_cron_statement
  end

  def submit_cron_statement(statement)
    visit root_path
    fill_in "statement", with: statement
    click_button "Submit"
  end

  def expect_cron_explaination
    expect(page).to have_content("The command #{command} will execute")
    expect(page).to have_content("at 12:00am every day")
  end

  def expect_invalid_cron_statement
    expect(page).to have_content("Unrecognized cron statement '#{invalid_statement}'.")
  end

  def expect_missing_cron_statement
    expect(page).to have_content("You must provide a cron statement.")
  end

  def expect_filled_form_field(statement)
    expect(page).to have_field("statement", with: statement)
  end
end
