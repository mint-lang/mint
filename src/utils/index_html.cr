module Mint
  # Renders the main HTML file based on a mint.json file and an environment.
  class IndexHtml
    getter json, env

    def self.render(env, relative = false, no_service_worker = false, no_icons = false, live_reload : Bool = true)
      new(env, relative, no_service_worker, no_icons, live_reload).to_s
    end

    def initialize(@env : Environment, @relative : Bool, @no_service_worker : Bool, @no_icons : Bool, @live_reload : Bool)
      @json = MintJson.parse_current
    end

    def path_for(url)
      if @relative
        url
      else
        "/#{url}"
      end
    end

    private def application
      json.application
    end

    ECR.def_to_s "#{__DIR__}/index_html.ecr"
  end
end
