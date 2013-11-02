require "spec_helper"

describe Cron do
  let(:command) { "./foo" }

  context ".new(attrs)" do
    it "remembers the attributes given to it" do
      cron = Cron.new(minute: "1")
      expect(cron.minute).to eq("1")
    end

    it "raises an error if given an attribute it doesn't understand" do
      expect { Cron.new(foo: "bar") }.to raise_error(NoMethodError)
    end
  end

  context "#command" do
    it "remembers the command given to it" do
      subject.command = command
      expect(subject.command).to eq(command)
    end
  end

  context "#schedule_description" do
    it "properly handles wildcards" do
      cron = Cron.new(minute: "*", hour: "*", day_of_month: "*", month: "*", day_of_week: "*", command: command)
      description = cron.schedule_description
      expect(description).to match /every minute/
      expect(description).to match /every hour/
      expect(description).to match /every day/
    end

    it "properly handles wildcard minutes but not hours" do
      cron = Cron.new(minute: "*", hour: "1", day_of_month: "*", month: "*", day_of_week: "*", command: command)
      description = cron.schedule_description
      expect(description).to match /every minute of  1am/
    end

    it "properly handles widcard hours but not minutes" do
      cron = Cron.new(minute: "2", hour: "*", day_of_month: "*", month: "*", day_of_week: "*", command: command)
      description = cron.schedule_description
      expect(description).to match /the 2nd minute of every hour/
    end

    it "properly handles widcard days but not months" do
      cron = Cron.new(minute: "*", hour: "*", day_of_month: "*", month: "2", day_of_week: "*", command: command)
      description = cron.schedule_description
      expect(description).to match /every day of February/
    end

    it "properly handles vanilla crons" do
      cron = Cron.new(minute: "1", hour: "2", day_of_month: "3", month: "4", day_of_week: "5", command: command)
      description = cron.schedule_description
      expect(description).to match /2:01/
      expect(description).to match /3rd of/
      expect(description).to match /April/
      expect(description).to match /Fridays/
    end

    it "properly handles ranges"
    it "properly handles modulo"

    context "knowing keyword schedules" do
      it "properly handles @reboot" do
        cron = Cron.new(schedule_keyword: "@reboot", command: command)
        expect(cron.schedule_description).to match /when the computer reboots/
      end

      it "properly handles @hourly" do
        cron = Cron.new(schedule_keyword: "@hourly", command: command)
        identical = Cron.new(minute: "0", hour: "*", day_of_month: "*", month: "*", day_of_week: "*", command: command)
        expect(cron.schedule_description).to eq(identical.schedule_description)
      end

      it "properly handles @daily" do
        cron = Cron.new(schedule_keyword: "@daily", command: command)
        identical = Cron.new(minute: "0", hour: "0", day_of_month: "*", month: "*", day_of_week: "*", command: command)
        expect(cron.schedule_description).to eq(identical.schedule_description)
      end

      it "properly handles @midnight" do
        cron = Cron.new(schedule_keyword: "@midnight", command: command)
        identical = Cron.new(minute: "0", hour: "0", day_of_month: "*", month: "*", day_of_week: "*", command: command)
        expect(cron.schedule_description).to eq(identical.schedule_description)
      end

      it "properly handles @monthly" do
        cron = Cron.new(schedule_keyword: "@monthly", command: command)
        identical = Cron.new(minute: "0", hour: "0", day_of_month: "1", month: "*", day_of_week: "*", command: command)
        expect(cron.schedule_description).to eq(identical.schedule_description)
      end

      it "properly handles @yearly" do
        cron = Cron.new(schedule_keyword: "@yearly", command: command)
        identical = Cron.new(minute: "0", hour: "0", day_of_month: "1", month: "1", day_of_week: "*", command: command)
        expect(cron.schedule_description).to eq(identical.schedule_description)
      end

      it "properly handles @annually" do
        cron = Cron.new(schedule_keyword: "@annually", command: command)
        identical = Cron.new(minute: "0", hour: "0", day_of_month: "1", month: "1", day_of_week: "*", command: command)
        expect(cron.schedule_description).to eq(identical.schedule_description)
      end
    end
  end
end
