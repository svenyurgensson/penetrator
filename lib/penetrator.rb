require "penetrator/inflector"
require "penetrator/version"

module Penetrator
  module Behavior

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def behave_like(trait_name, *args)
        trait_name = "#{Penetrator::Inflector.camelize(trait_name.to_s)}Trait"
        trait = Penetrator::Inflector.constantize(trait_name)
        include trait
      end
    end

  end
end

Object.send :include, Penetrator::Behavior
