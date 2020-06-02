require 'fastlane/action'
require 'fastlane'

class BaseHelper 
    def sh(command)
        Actions::sh(command)
      end
end