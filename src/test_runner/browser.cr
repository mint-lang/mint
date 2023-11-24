module Mint
  class TestRunner
    class Browser
      include Errorable

      # The available browsers which we can connect to.
      BROWSER_PATHS = {
        firefox: [
          "/Applications/Firefox.app/Contents/MacOS/firefox-bin",
          "firefox-bin",
          "firefox",
        ],
        chrome: [
          "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
          "chromium-browser",
          "google-chrome",
          "chromium",
        ],
      }

      # The data for the browser session (process and profile directory).
      @data : Tuple(Process, String)?
      @browser : String
      @path : String

      def initialize(@browser)
        @channel = Channel(Nil).new
        @path = resolve
      end

      def resolve : String
        paths =
          BROWSER_PATHS[@browser] || [] of String

        path =
          paths
            .compact_map { |item| Process.find_executable(item) }
            .first?

        error! :browser_not_found do
          block do
            text "I cannot find the executable of browser:"
            bold @browser
          end

          block do
            text "Are you sure it's installed properly?"
          end
        end unless path

        path
      end

      def open(path)
        profile_directory =
          Path[Dir.tempdir, Random.new.hex(5)]
            .to_s
            .tap { |directory| Dir.mkdir(directory) }

        begin
          # Start the browser process
          process =
            start(path, profile_directory)

          # Save the data for cleanup later
          @data =
            {process, profile_directory}

          # When the program finishes cleanup
          # the process and profile directory
          at_exit { cleanup }

          # Wait for the signal, this keeps this thread active.
          @channel.receive
        ensure
          cleanup
        end
      end

      def cleanup
        @data.try do |(process, profile_directory)|
          process.signal(:kill) rescue nil
          FileUtils.rm_rf(profile_directory)
        end

        @data = nil
      end

      def stop
        @channel.send(nil)
      end

      def start(url, profile_directory)
        case @browser
        when "firefox"
          Process.new(@path, args: [
            "--remote-debugging-port", "9222",
            "--profile", profile_directory,
            "--window-size", "1920,1080",
            "--headless",
            url,
          ])
        when "chrome"
          Process.new(@path, args: [
            "--profile-directory=#{profile_directory}",
            "--remote-debugging-port=9222",
            "--window-size=1920,1080",
            "--disable-gpu",
            "--headless",
            url,
          ])
        else
          error! :invalid_browser do
            block do
              text "I cannot run the tests in the given browser:"
              bold @browser
            end

            snippet "The available browsers are:", "chrome, firefox"
          end
        end
      end
    end
  end
end
