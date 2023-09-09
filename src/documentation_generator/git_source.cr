module Mint
  class DocumentationGeneratorHtml
    class GitSource
      @root : String = ""
      @url : String = ""
      @url_pattern : String = ""
      @ref : String = ""
      @user : String = ""
      @repo : String = ""

      getter url, user, repo

      def initialize(url : String | Nil, url_pattern : String | Nil, ref : String | Nil)
        @root = git_root

        @url =
          if url
            url
          else
            parse_remote_git_url
          end

        @ref =
          if ref
            ref
          else
            parse_latest_git_ref
          end

        user_repo = parse_user_and_repo
        @user = user_repo[0]
        @repo = user_repo[1]

        @url_pattern =
          if url_pattern
            url_pattern
          elsif @url.includes?("github")
            "https://github.com/#{@user}/#{@repo}/blob/{ref}/{path}#L{line}"
          elsif @url.includes?("gitlab")
            "https://gitlab.com/#{@user}/#{@repo}/blob/{ref}/{path}#L{line}"
          elsif @url.includes?("bitbucket")
            "https://bitbucket.org/#{@user}/#{@repo}/src/{ref}/{path}#cl-{line}"
          else
            ""
          end

        if [@url, @ref, @url_pattern, @repo, @user].any? { |s| s == "" }
          Render::Terminal::STDOUT.puts "#{COG} Please provide a valid --git-url or --git-url-pattern. Source links will not be generated."
        end
      end

      def git_root : String
        begin
          `git rev-parse --show-toplevel`.strip
        rescue
          ""
        end
      end

      def parse_remote_git_url : String
        remote =
          begin
            `git remote -v`.strip
          rescue
            ""
          end

        if match = /^\w*\s*(.*)\/(.*)\/(.*).git/.match(remote) # matches "origin https://github.com/mint-lang/mint.git
          return "#{$1}/#{$2}/#{$3}"
        elsif match = /^.*\@(.*):(.*)\/(.*).git/.match(remote) # matches "origin git@github.com:mint-lang/mint.git"
          return "https://#{$1}/#{$2}/#{$3}"
        else
          ""
        end
      end

      def parse_user_and_repo : Tuple(String, String)
        if match = /[https?:\/\/]?(.*)\/(.*)\/(.*)\/?/.match(@url)
          {$2, $3}
        else
          {"", ""}
        end
      end

      def parse_latest_git_ref : String
        `git tag -l | sort -V`.split.select { |t| t.strip != "" }.last
      end

      def get_node_url(node : Ast::Node) : String
        path = node.location.filename.sub("#{@root}/", "")
        line = node.location.start[0]

        @url_pattern
          .sub("{user}", @user)
          .sub("{repo}", @repo)
          .sub("{ref}", @ref)
          .sub("{path}", path)
          .sub("{line}", line)
      end
    end
  end
end
