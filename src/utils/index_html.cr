module Mint
  # Renders the main HTML file based on a mint.json file and an environment.
  class IndexHtml
    @relative : Bool
    @no_manifest : Bool
    @no_service_worker : Bool
    @no_icons : Bool
    @inline : Bool
    @index_js : String
    @index_css : String
    @live_reload : Bool

    getter env : Environment
    getter json : MintJson

    def self.render(
      env : Environment,
      relative = false,
      no_manifest = false,
      no_service_worker = false,
      no_icons = false,
      inline = false,
      index_js = "",
      index_css = "",
      live_reload = true
    ) : String
      new(
        env, relative, no_manifest, no_service_worker, no_icons, inline,
        index_js, index_css, live_reload).to_s
    end

    def initialize(
      @env : Environment,
      @relative,
      @no_manifest,
      @no_service_worker,
      @no_icons,
      @inline,
      @index_js,
      @index_css,
      @live_reload
    )
      @json = MintJson.parse_current
    end

    protected def path_for(url)
      @relative ? url : "/#{url}"
    end

    protected delegate :application,
      to: json

    ECR.def_to_s "#{__DIR__}/index_html.ecr"
  end
end
