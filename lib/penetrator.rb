# -*- encoding : utf-8 -*-
require "penetrator/inflector"
require "penetrator/version"

module Penetrator
  module Behavior

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def behave_like(trait_name, *args)
        full_name = "#{Penetrator::Inflector.camelize(trait_name.to_s)}Trait"
        trait = Penetrator::Inflector.constantize(full_name)
        trait_args_var = "@@" + trait_name.to_s.downcase.gsub(/[^_a-z]+/, '_')+"_args"
        self.class_variable_set(trait_args_var.to_sym, (args || nil))
        include trait
      end
    end

  end
end

Object.send :include, Penetrator::Behavior
