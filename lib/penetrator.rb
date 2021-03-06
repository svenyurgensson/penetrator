# -*- encoding : utf-8 -*-
require "penetrator/inflector"

module Penetrator
  autoload :Version, 'penetrator/version'

  module Concern
    def self.extended(base) #:nodoc:
      base.instance_variable_set("@_dependencies", [])
    end

    def append_features(base)
      if base.instance_variable_defined?("@_dependencies")
        base.instance_variable_get("@_dependencies") << self
        return false
      else
        return false if base < self
        @_dependencies.each { |dep| base.send(:include, dep) }
        super
        base.extend const_get("ClassMethods") if const_defined?("ClassMethods")
        return unless instance_variable_defined?("@_included_block")
        if @_trait_block
          base.class_exec(*@_trait_args, @_trait_block, &@_included_block)
        else
          base.class_exec(*@_trait_args, &@_included_block)
        end
      end
    end

    def extend_object(obj)
      super
      return unless instance_variable_defined?("@_included_block")
      if @_trait_block
        (class << obj; self; end).instance_exec(*@_trait_args, @_trait_block, &@_included_block)
      else
        (class << obj; self; end).instance_exec(*@_trait_args, &@_included_block)
      end
    end

    def included(base = nil, &block)
      if base.nil?
        @_included_block = block
      else
        super
      end
    end
  end # Concern

  module Behavior
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def behaves_like(trait_name, *args, &block)
        full_name = "#{Penetrator::Inflector.camelize(trait_name.to_s)}Trait"
        trait = Penetrator::Inflector.constantize(full_name)
        trait.instance_variable_set(:@_trait_args, args)
        trait.instance_variable_set(:@_trait_block, block)
        include trait
      end
    end # ClassMethods

    def behaves_like(trait_name, *args, &block)
      full_name = "#{Penetrator::Inflector.camelize(trait_name.to_s)}Trait"
      trait = Penetrator::Inflector.constantize(full_name)
      trait.instance_variable_set(:@_trait_args, args)
      trait.instance_variable_set(:@_trait_block, block)
      extend trait
    end
  end # Behavior

end

Object.send :include, Penetrator::Behavior
