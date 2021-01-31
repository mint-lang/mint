module LSP
  # This is the class for a language server, it handles HTTP over IO.
  #
  # Subclass this to create a server for a specific language:
  #
  #   class Server < LSP::Server
  #     method "text/didChange", DidChangeRequest
  #   end
  #
  class Server
    @@methods = {} of String => RequestMessage.class | NotificationMessage.class

    macro method(name, message)
      @@methods[{{name}}] = {{message}}
    end

    def initialize(@in : IO, @out : IO)
    end

    def prepend_header(content : String)
      "Content-Length: #{content.bytesize}\r\n\r\n#{content}"
    end

    # Sends the given message (with headers prepended) to the output IO.
    def send(result = nil, error = nil, id = nil, method = nil, params = nil)
      @out << prepend_header({
        "jsonrpc" => "2.0",
        "method"  => method,
        "params"  => params,
        "result"  => result,
        "error"   => error,
        "id"      => id,
      }.compact.to_json)

      @out.flush
    end

    # A method to send a show message request
    def show_message_request(message : String, type = 4)
      send(
        method: "window/showMessageRequest",
        id: UUID.random.to_s,
        params: {
          message: message.to_s,
          type:    type,
        })
    end

    # A method to send a log message notification
    def log(message : String, type = 4)
      send(
        method: "window/logMessage",
        params: {
          message: message.to_s,
          type:    type,
        })
    end

    # Reads a message from the input IO, and converts to a Message object,
    # calls execute on it and send the result if it's a request message.
    def read
      MessageParser.parse(@in) do |contents|
        # Parse the contents as JSON
        json =
          JSON.parse(contents)

        # Get the method name
        name =
          json["method"]?

        # If we have a method name get the method class
        if name
          method =
            @@methods[name.as_s]?

          # If the given method is implemented
          # get an instance using the contents
          if method
            message =
              method.from_json(contents)

            result =
              message.execute(self)

            case message
            when RequestMessage
              send(id: message.id, result: result)
            end
          end
        end
      end
    rescue error
      log(error.to_s)
      error.backtrace?.try(&.each { |item| log(item) })
    end
  end
end
