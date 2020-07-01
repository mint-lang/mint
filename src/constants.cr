module Mint
  enum Environment
    DEVELOPMENT
    BUILD
  end

  ICON_SIZES =
    [16, 32, 36, 48, 57, 72, 76, 96, 120, 128, 144, 152, 167, 180, 192, 196, 256, 512]

  COG       = "⚙".colorize(:light_green).mode(:dim).to_s
  ARROW     = "➔".colorize(:dark_gray).to_s
  CHECKMARK = "✔".colorize(:light_green).to_s
  DIAMOND   = "◈"

  DIST_DIR   = "dist"
  PUBLIC_DIR = "public"
  CSS_DIR    = File.join(DIST_DIR, "css")
end
