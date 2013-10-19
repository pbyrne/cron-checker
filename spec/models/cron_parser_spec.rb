require "spec_helper"

describe CronParser do
  let(:command) { "./foo" }
  let(:statement) { "* * * * * #{command}" }
  let(:invalid_statement) { "asdf" }

  subject { CronParser.new(statement) }

  context ".new(statement)" do
    it "remembers the statement given to it" do
      expect(CronParser.new(statement).statement).to eq(statement)
    end
  end

  context "#valid?" do
    it "is false for blank statements" do
      subject.statement = nil
      expect(subject).to_not be_valid
    end

    it "is true for special-case cron keywords followed by a command" do
      subject.statement = "@reboot #{command}"
      expect(subject).to be_valid
      subject.statement = "@reboot"
      expect(subject).to_not be_valid
    end

    it "is true for long-form schedules followed by a command" do
      subject.statement = "* * * * * #{command}"
      expect(subject).to be_valid
      subject.statement = "* * * * *"
      expect(subject).to_not be_valid
    end
  end

  context "#cron" do
    it "returns a new Cron instance for traditional schedules" do
      cron = CronParser.new("1 2 3 4 5 #{command}").cron
      expect(cron.minute).to eq("1")
      expect(cron.hour).to eq("2")
      expect(cron.day_of_month).to eq("3")
      expect(cron.month).to eq("4")
      expect(cron.day_of_week).to eq("5")
      expect(cron.command).to eq(command)
    end

    it "returns a new Cron instance for special schedule commands" do
      cron = CronParser.new("@reboot #{command}").cron
      expect(cron.command).to eq(command)
      expect(cron.schedule_keyword).to eq("@reboot")
    end

    it "raises an exception for an invalid statement" do
      subject.statement = "asdf"
      expect { subject.cron }.to raise_error(CronParser::InvalidStatement)
    end

    it "raises an exception for a missing statement" do
      subject.statement = nil
      expect { subject.cron }.to raise_error(CronParser::MissingStatement)
      subject.statement = ""
      expect { subject.cron }.to raise_error(CronParser::MissingStatement)
    end
  end
end
