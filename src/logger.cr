module Mint::Logger
  def log(message)
    printf message
    result = nil
    elapsed = Time.measure { result = yield }
    printf TimeFormat.auto(elapsed).colorize.mode(:bold).to_s + "\n"
    result
  end

  def arrow
    "➔".colorize(:dark_gray).to_s
  end

  def cog
    "⚙".colorize(:dark_gray).to_s
  end
end

module Terminal
  extend self

  def separator
    ("᐀" * 100).colorize.mode(:dim)
  end

  def arrow
    "➜".colorize.mode(:dim)
  end

  def diamond
    "◈"
  end

  def checkmark
    "✔".colorize(:light_green)
  end

  def cog
    "⚙".colorize(:light_green)
  end
end
