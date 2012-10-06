# -*- encoding : utf-8 -*-
require 'penetrator'
require 'minitest/spec'
require 'minitest/autorun'

describe 'when object of any class extended by trait' do
  module ObjectRelatedTrait
    extend Penetrator::Concern
    def testing_method
      "It Works!"
    end
  end

  it 'could extend particular object' do
     object = Object.new
     object.behaves_like "object_related"

     object.must_respond_to :testing_method
     object.testing_method.must_be :==, 'It Works!'
  end

  it 'not extend others objects the same class' do
     object = Object.new
     object.behaves_like "object_related"

     second_object = Object.new
     second_object.wont_respond_to :testing_method
  end

end

describe 'behavior when trait parameterized by arguments passed into included module' do
  module CanHaveArgsTrait
    extend Penetrator::Concern
    included do |*args|
      args.each do |method_name|
        define_method(method_name) do
          method_name.to_s
        end
      end
    end # included
  end # CanHaveArgs

  it 'receive trait arguments' do
    object = Object.new
    object.behaves_like :CanHaveArgs, 'arg1', 'arg2'

    object.must_respond_to :arg1
    object.arg1.must_be :==, 'arg1'
    object.must_respond_to :arg2
    object.arg2.must_be :==, 'arg2'
  end

end # trait argument
