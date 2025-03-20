require "../spec_helper"

describe "URI.file_path" do
  it "returns unix file path" do
    URI.parse("file://etc/hosts").file_path.should eq("/hosts")
  end

  it "return unix file path" do
    URI.parse("file:///etc/hosts").file_path.should eq("/etc/hosts")
  end

  it "return windows file path" do
    URI.parse("file:///c:/project/readme.md").file_path.should eq("C:\\project\\readme.md")
    URI.parse("file:///C%3A/project/readme.md").file_path.should eq("C:\\project\\readme.md")
  end
end
