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
    it "returns a new Cron instance for traditional schedules"
    it "returns a new Cron instance for special schedule commands"

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
