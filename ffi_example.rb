require 'ffi'

module MyLibcWrapper
    extend FFI::Library
      ffi_lib FFI::Library::LIBC
        attach_function :getpid, [], :int
end

puts MyLibcWrapper.getpid
puts $$
