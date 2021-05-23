module Mint
  class Parser
    class SkipError < Exception
    end

    # This is similar to `raise(Exception)` except that it doesn't compute a callstack.
    def raise(exception : Mint::Parser::SkipError) : NoReturn
      unwind_ex = Pointer(LibUnwind::Exception).malloc
      unwind_ex.value.exception_class = LibC::SizeT.zero
      unwind_ex.value.exception_cleanup = LibC::SizeT.zero
      unwind_ex.value.exception_object = exception.as(Void*)
      unwind_ex.value.exception_type_id = exception.crystal_type_id
      __crystal_raise(unwind_ex)
    end
  end
end
