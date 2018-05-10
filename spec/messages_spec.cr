require "./spec_helper"

ERROR_MESSAGES.each do |error|
  it "#{error} has a message file" do
    File.exists?("./src/messages/#{error}.cr").should eq(true)
  end
end

Dir.glob("./src/messages/**/*").each do |file|
  basename = File.basename(file)[0..-4]

  it "#{basename} has an associated error" do
    ERROR_MESSAGES.includes?(basename).should eq(true)
  end
end
