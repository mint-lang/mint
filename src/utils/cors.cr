module Mint
  class CORS
    include HTTP::Handler

    def call(context)
      context.response.headers["Access-Control-Max-Age"] = 1.day.total_seconds.to_i.to_s
      context.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH"
      context.response.headers["Access-Control-Allow-Headers"] = "Content-Type"
      context.response.headers["Access-Control-Allow-Credentials"] = "true"
      context.response.headers["Access-Control-Allow-Origin"] = "*"

      if context.request.method.upcase == "OPTIONS"
        context.response.content_type = "text/html; charset=utf-8"
        context.response.status = :ok
      else
        call_next context
      end
    end
  end
end
