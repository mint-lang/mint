module Mint
  enum Environment
    DEVELOPMENT
    BUILD
  end

  ICON_SIZES =
    [16, 32, 36, 57, 76, 96, 120, 128, 144, 152, 167, 180, 196, 256, 512]

  COG       = "⚙".colorize(:light_green).mode(:dim).to_s
  ARROW     = "➔".colorize(:dark_gray).to_s
  CHECKMARK = "✔".colorize(:light_green).to_s
  DIAMOND   = "◈"
end
