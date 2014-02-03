require 'ffi'
 
module MyLibcWrapper
  extend FFI::Library
  ffi_lib FFI::Library::LIBC
 
  # define a FFI Struct to hold the data that we can retrieve
  class UTSName < FFI::Struct
    layout :sysname   , [:char, 65],
           :nodename  , [:char, 65],
           :release   , [:char, 65],
           :version   , [:char, 65],
           :machine   , [:char, 65],
           :domainname, [:char, 65]
 
    def to_hash
      Hash[members.zip values.map(&:to_s)]
    end
  end
 
  # takes a pointer, returns an integer
  attach_function :uname, [:pointer], :int
 
  def self.uname_info
    uts = UTSName.new # create a place in memory to hold the data
    raise 'uname info unavailable' if uname(uts) != 0 # retrieve data
    uts.to_hash
  end
end
 
puts MyLibcWrapper.uname_info