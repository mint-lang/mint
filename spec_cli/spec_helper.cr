require "file_utils"
require "spec"

require "../src/constants"
require "../src/version"

require "../spec/spec_helpers"

def run(args : Array(String), input : String = "")
  input_io, output, error =
    {IO::Memory.new(input), IO::Memory.new, IO::Memory.new}

  path =
    Path[__DIR__, "..", "bin", "mint"].normalize.to_s

  status =
    Process.run(
      clear_env: true,
      input: input_io,
      output: output,
      command: path,
      error: error,
      args: args,
      env: {
        "NO_COLOR" => "1",
      })

  {
    output.rewind.gets_to_end,
    error.rewind.gets_to_end,
    status,
  }
end

def expect_output(args : Array(String), template : String, input : String = "")
  output, _, status =
    run args, input

  status.normal_exit?.should eq(true)
  matches_template(template.rstrip, output.rstrip)
end
