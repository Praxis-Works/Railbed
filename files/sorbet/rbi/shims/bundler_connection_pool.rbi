# typed: true

# Bundler vendors connection_pool, and Tapioca can observe this module while
# compiling ffi without emitting Bundler's private constant definitions.
module Bundler
  class ConnectionPool
    module ForkTracker; end
  end
end
