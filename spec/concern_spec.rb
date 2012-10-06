# -*- encoding : utf-8 -*-
require 'penetrator'
require 'minitest/spec'
require 'minitest/autorun'

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
    class Victim
      behaves_like :CanHaveArgs, 'arg1', 'arg2'
    end
    obj = Victim.new
    obj.must_respond_to :arg1
    obj.arg1.must_be :==, 'arg1'
    obj.must_respond_to :arg2
    obj.arg2.must_be :==, 'arg2'

    class OtherVictim
      behaves_like :CanHaveArgs
    end
    obj = OtherVictim.new
    obj.wont_respond_to :arg1
    obj.wont_respond_to :arg2
  end

end # trait argument

describe 'behavior when trait add ClassMethods and Instance methods' do
   module RichTrait
     extend Penetrator::Concern
     module ClassMethods
       def class_method
       end
     end

     def instance_method
     end
   end

   it 'add class and instance methods from traits' do
     class VictimWithNoArguments
       behaves_like 'rich'
     end
     obj = VictimWithNoArguments.new
     obj.must_respond_to :instance_method
     VictimWithNoArguments.must_respond_to :class_method
   end
end


 describe 'behavior when trait add ClassMethods and Instance methods alongside with existing' do
   module SuperRichTrait
     extend Penetrator::Concern
     module ClassMethods
       def class_method(arg)
         "From Trait with chaining"
       end
     end

     def instance_method(arg)
       "From Trait with chaining"
     end
   end

   it 'add class and instance methods from traits' do
     class Innocent
       def self.class_method arg
         "This is class argument: #{arg} " + super
       end
       def instance_method arg
         "This is instance argument: #{arg} " + super
       end

       behaves_like 'super_rich'
     end

     obj = Innocent.new
     obj.instance_method('iarg').must_be :==, 'This is instance argument: iarg From Trait with chaining'
     Innocent.class_method('carg').must_be :==, 'This is class argument: carg From Trait with chaining'
   end

end
