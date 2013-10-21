require "spec_helper"

describe Cron do
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
      subject.command = "foo"
      expect(subject.command).to eq("foo")
    end
  end
end
