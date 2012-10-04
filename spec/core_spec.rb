# -*- encoding : utf-8 -*-
require 'penetrator'
require 'minitest/spec'
require 'minitest/autorun'
require 'mocha'

describe 'Class' do
  it 'should be accesable' do
    Class.must_respond_to :behaves_like
  end
end # Class method


describe 'mixing behavior' do

  module FirstTrait
    def test; end
  end

  it 'add trait methods' do
    class Victim
      behaves_like 'first'
    end

    Victim.new.must_respond_to :test
  end


  module Outer
    module InnerTrait
      def inner_test; end
    end
  end


  it 'add traits methods from nested modules' do
    class Victim
      behaves_like 'outer/inner'
    end
    Victim.new.must_respond_to :inner_test
  end

end # mixing behavior


describe 'methods chainings' do

  module SuperTrait
    def test
      'from trait'
    end
  end

  it 'have traits methods' do
    class Victim
      behaves_like 'super'
      def test
        'this from class and that ' + super
      end
    end # Victim

    Victim.new.test.must_equal 'this from class and that from trait'
  end

end # methods chainings

describe 'callbacks' do
  module CallbackTrait
  end

  it 'have traits methods' do
    class Victim; end
    CallbackTrait.expects(:included).with(Victim)
    class Victim
      behaves_like 'callback'
    end
  end
end # callbacks

describe 'visibility' do
  module VisibilityTrait
    def public_method_from_trait;    end
    protected
    def protected_method_from_trait; end
    private
    def private_method_from_trait;   end
  end

  it 'allow trait to define methods with different visibility' do
    class Victim
      behaves_like 'visibility'
    end

    instance = Victim.new
    instance.public_methods.collect(&:to_s).must_include('public_method_from_trait')
    instance.protected_methods.collect(&:to_s).must_include('protected_method_from_trait')
    instance.private_methods.collect(&:to_s).must_include('private_method_from_trait')

  end

end # visibility
