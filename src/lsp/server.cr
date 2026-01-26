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
    def initialize(@in : IO, @out : IO)
    end

    def prepend_header(content : String)
      "Content-Length: #{content.bytesize}\r\n\r\n#{content}"
    end

    def send(content : String)
      @out << prepend_header(content)
      @out.flush
    end

    def send_notification(method, params)
      send({
        "jsonrpc" => "2.0",
        "method"  => method,
        "params"  => params,
      }.to_json)
    end

    def send_request(id, method, params)
      send({
        "jsonrpc" => "2.0",
        "method"  => method,
        "params"  => params,
        "id"      => id,
      }.to_json)
    end

    def send_response(id, result)
      send({
        "jsonrpc" => "2.0",
        "result"  => result,
        "id"      => id,
      }.to_json)
    end

    # A method to send a show message request
    def show_message_request(message : String, type = 4)
      send_request(
        id: UUID.random.to_s,
        method: "window/showMessageRequest",
        params: {
          message: message.to_s,
          type:    type,
        })
    end

    # A method to send a log message notification
    def log(message : String, type = 4)
      send_request(
        id: UUID.random.to_s,
        method: "window/logMessage",
        params: {
          message: message.to_s,
          type:    type,
        })
    end

    def process(contents)
      # Parse the contents as JSON
      json =
        JSON.parse(contents)

      # Get the method name
      name =
        json["method"]?

      # If we have a method name get the method class
      if name
        method =
          @methods[name.as_s]?

        # If the given method is implemented
        # get an instance using the contents
        if method
          message =
            method.from_json(contents)

          result =
            message.execute(self)

          case message
          when RequestMessage
            send_response(id: message.id, result: result)
          end
        end
      end
    rescue error
      show_message_request(error.to_s)
      # log()
      # error.backtrace?.try(&.each { |item| log(item) })
    end

    # Reads a message from the input IO, and converts to a Message object,
    # calls execute on it and send the result if it's a request message.
    def read
      return exit(1) if @in.closed?
      MessageParser.parse(@in, &->process(String))
    rescue IO::EOFError
      # Client has exited unexpectedly without
      # sending an "exit" lifecycle message
      exit(1)
    end
  end
end
