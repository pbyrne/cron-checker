# encoding: UTF-8
require File.join(File.dirname(__FILE__), "/../spec_helper")

describe Cron do
  context "initializing" do
    before(:each) do
      @c = Cron.new("1 2 3 4 5 echo 'hello, world'")
    end

    it "should accept the cron statement" do
      @c.should be_a_kind_of(Cron)
      @c.valid?.should be_true
    end

    it "should reject an incomplete cron statement" do
      @d = Cron.new("foo")

      @d.valid?.should be_false
    end

    it "should accept five numbers and a single-word command" do
      @d = Cron.new("1 2 3 4 5 ls")

      @d.valid?.should be_true
    end

    it "should reject a cron statement with invalid entries" do
      # pending("Might need to move the parsing into the initialization, retaining the plain-english as instance variables")
      @d = Cron.new("* foo bar bing bang echo 'hello, world'")

      @d.valid?.should be_false
    end

    it "should reject a cron statement with an invalid day of week number range" do
      @d = Cron.new("* * * * 10-20 echo 'hello, world'")

      @d.valid?.should be_false
    end

    it "should reject a cron statement with an invalid day of week number list with * from day of month" do
      @d = Cron.new("* * * * 10,15,20 echo 'hello, world'")

      @d.valid?.should be_false
    end

    it "should reject a cron statement with an invalid day of week number list in a given day of month" do
      @d = Cron.new("* * 1 * 10,15,20 echo 'hello, world'")

      @d.valid?.should be_false
    end

    it "should reject a cron statement with an invalid day of week number list of ranges in a given day of month" do
      @d = Cron.new("* * 1 * 1-5,10-20 echo 'hello, world'")

      @d.valid?.should be_false
    end

    it "should retain the statement" do
      @c.statement.should == "1 2 3 4 5 echo 'hello, world'"
    end

    it "should parse the minute from the statement" do
      @c.minute.should == "1"
    end

    it "should parse the hour from the statement" do
      @c.hour.should == "2"
    end

    it "should parse the day of month from the statement" do
      @c.dom.should == "3"
    end

    it "should parse the month from the statement" do
      @c.month.should == "4"
    end

    it "should parse the day of week from the statement" do
      @c.dow.should == "5"
    end

    it "should parse the command from the statement" do
      @c.command.should == "echo 'hello, world'"
    end
  end

  context "displaying the output in plain english" do
    it "should handle stars" do
      @c = Cron.new("* * * * * echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute every minute of every hour on every day of every month."
    end

    it "should handle numbers" do
      @c = Cron.new("1 2 3 4 5 echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute at 2:01am on the 3rd and every Friday of April."
    end

    it "should handle explicit words for months" do
      @c = Cron.new("* * * mar * echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute every minute of every hour on every day in March."
    end

    it "should handle explicit words for days of the week" do
      @c = Cron.new("* * * * Sun echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute every minute of every hour on every Sunday of every month."
    end

    it "should handle steps for hours and minutes" do
      @c = Cron.new("*/3 */4 * * * echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute every 3 minutes of every 4 hours on every day of every month."
    end

    it "should handle ranges in the non-days-of-week fields" do
      @c = Cron.new("1-2 3-4 5-6 7-8 * echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute the 1st–2nd minutes of the 3rd–4th hours on the 5th–6th of July–August."
    end

    it "should also handle ranges in the days of the week" do
      @c = Cron.new("* * * * 3-4 echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute every minute of every hour on Wednesday–Thursday of every month."
    end

    it "should also handle lists of numbers" do
      @c = Cron.new("1,3 2,5,10 9,10 5,9 3,4 echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute the 1st and 3rd minutes of the 2nd, 5th, and 10th hours of the 9th and 10th and every Wednesday and Thursday of May and September."
    end

    it "should also handle lists of ranges" do
      @c = Cron.new("1-4,5-6,10-12 2-4,9-10 1-3,20-22 2-4,6-8 2-3,5-6 echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute the 1st–4th, 5th–6th, and 10th–12th minutes of the 2nd–4th and 9th–10th hours of the 1st–3rd and 20th–22nd and every Tuesday–Wednesday and Friday–Saturday of February–April and June–August."
    end

    it "should also handle ranges with steps" do
      @c = Cron.new("1-9/2 5-10/3 10-20/4 1-10/5 2-6/2 echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute every 2 minutes in the 1st–9th minutes of every 3 hours in the 5th–10th hours of every 4 days in the 10th–20th and every 2 days in every Tuesday–Saturday of every 5 months in January–October."
    end

    it "should also handle @reboot" do
      @c = Cron.new("@reboot echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute when the computer reboots."
    end

    it "should also handle @hourly" do
      @c = Cron.new("@hourly echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute the 0th minute of every hour on every day of every month."
    end

    it "should also handle @daily" do
      @c = Cron.new("@daily echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute at 12:00am on every day of every month."
    end

    it "should also handle @midnight" do
      @c = Cron.new("@midnight echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute at 12:00am on every day of every month."
    end

    it "should also handle @monthly" do
      @c = Cron.new("@monthly echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute at 12:00am on the 1st of every month."
    end

    it "should also handle @yearly" do
      @c = Cron.new("@yearly echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute at 12:00am on the 1st of January."
    end

    it "should also handle @annually" do
      @c = Cron.new("@annually echo 'hello, world'")

      @c.to_s.should == "The command <code>echo 'hello, world'</code> will execute at 12:00am on the 1st of January."
    end
  end

  context "handling the actual crons being searched on the site" do
    it "should accept 0 5 1 */2 *" do
      @c = Cron.new("0 5 1 */2 * payroll.sh")

      @c.to_s.should == "The command <code>payroll.sh</code> will execute at 5:00am on the 1st of every 2nd month."
    end

    it "should not accept 0 for the month" do
      @c = Cron.new("0 0 0 0 0 echo 'hello, world'")

      @c.should_not be_valid
    end

    it "should accept 7 for the day of week" do
      @c = Cron.new("0 5 8-31 * 7 /backup2/netfinity/weekly.sh")

      @c.to_s.should == "The command <code>/backup2/netfinity/weekly.sh</code> will execute at 5:00am on the 8th–31st and every Sunday of every month."
    end

    it "should accept * 5 1-7 * 0" do
      @c = Cron.new("* 5 1-7 * 0 /backup2/netfinity/monthly.sh")

      @c.to_s.should == "The command <code>/backup2/netfinity/monthly.sh</code> will execute every minute of 5am on the 1st–7th and every Sunday of every month."
    end
  end
end
