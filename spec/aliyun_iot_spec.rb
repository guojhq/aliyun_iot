RSpec.describe AliyunIot do
  it "has a version number" do
    expect(AliyunIot::VERSION).not_to be nil
  end

  it "exposes the main API classes" do
    expect(defined?(AliyunIot::Queue)).to be_truthy
    expect(defined?(AliyunIot::Topic)).to be_truthy
    expect(defined?(AliyunIot::Product)).to be_truthy
  end

  it "returns a configuration object" do
    expect(AliyunIot.configuration).to be_a(OpenStruct)
  end
end
