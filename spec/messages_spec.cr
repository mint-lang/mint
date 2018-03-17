require "./spec_helper"

ERROR_MESSAGES.each do |error|
  it "#{error} has a message file" do
    File.exists?("./src/messages/#{error}").should eq(true)
  end
end

Dir.glob("./src/messages/**/*").each do |file|
  basename = File.basename(file)

  it "#{basename} has an associated error" do
    ERROR_MESSAGES.includes?(basename).should eq(true)
  end

  it file do
    html = Myhtml::Parser.new(File.read(file))
    body = html.nodes(:body).first

    article = body.children.select(&.tag_sym.!=(:_text)).first
    article.tag_sym.should eq(:article)

    children = article.children.select(&.tag_sym.!=(:_text)).to_a

    h2 = children.shift
    h2.tag_sym.should eq(:h2)

    snippet = article.children.to_a.last
    snippet.tag_text.strip.should match(/\{{2}(node|snippet|other)\}{2}/)
  end
end
