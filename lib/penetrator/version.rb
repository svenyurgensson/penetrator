# -*- encoding : utf-8 -*-

module Penetrator
  # Contains information about this gem's version
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 8

    # Returns a version string by joining <tt>MAJOR</tt>, <tt>MINOR</tt>, and <tt>PATCH</tt> with <tt>'.'</tt>
    #
    # Example
    #
    #   Version.to_s # '1.0.2'
    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end
end
