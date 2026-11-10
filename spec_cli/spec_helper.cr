require "file_utils"
require "spec"

require "../src/ext/string"
require "../src/constants"
require "../src/version"

require "../spec/spec_helpers"

def run(args : Array(String), input : String = "", clear_env = true)
  input_io, output, error =
    {IO::Memory.new(input), IO::Memory.new, IO::Memory.new}

  path =
    Path[__DIR__, "..", "bin", "mint"].normalize.to_s

  # On Windows the binary needs `PATH` to find the DLLs it is linked against,
  # without them it exits before `main` runs (no output, no exit code).
  {% if flag?(:windows) %}
    clear_env = false
  {% end %}

  status =
    Process.run(
      clear_env: clear_env,
      input: input_io,
      output: output,
      command: path,
      error: error,
      args: args,
      env: {
        "NO_COLOR" => "1",
      })

  # A command is allowed to fail (that's what some of the specs check) but it
  # must not crash, otherwise the specs fail in confusing ways later on.
  unless status.normal_exit?
    raise <<-TEXT
      COMMAND CRASHED!

      COMMAND:
      #{path} #{args.join(' ')}

      EXIT:
      #{status.exit_reason}

      OUTPUT:
      #{output.rewind.gets_to_end}

      ERROR:
      #{error.rewind.gets_to_end}
      TEXT
  end

  {
    output.rewind.gets_to_end,
    error.rewind.gets_to_end,
    status,
  }
end

def expect_output(args : Array(String), template : String, input : String = "", clear_env = true)
  output, _, status =
    run args, input, clear_env

  status.normal_exit?.should eq(true)
  matches_template(template.rstrip, output.rstrip)
end
