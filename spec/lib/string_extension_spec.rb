require File.join(File.dirname(__FILE__), "/../spec_helper")

describe String, "knowing whether the string ends or begins with a given string" do
  it "rerturns true when the string begins with the given string" do
    "abcdefg".starts_or_ends_with?("abc").should be_true
  end
  
  it "returns false when the string does not begin with the given string" do
    "abcdefg".starts_or_ends_with?("zyx").should be_false
  end
  
  it "rerturns true when the string ends with the given string" do
    "abcdefg".starts_or_ends_with?("fg").should be_true
  end

  it "returns false when the string does not end with the given string" do
    "abcdefg".starts_or_ends_with?("zyx").should be_false
  end
end