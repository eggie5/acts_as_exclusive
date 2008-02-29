require 'active_record'

module BearBrand
  module Acts
    module Exclusive
      def self.included(base)
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_exclusive
          extend Exclusive::SingletonMethods
          include Exclusive::InstanceMethods
        end
      end
      
      # add your class methods here
      module SingletonMethods
        def cluck
          'cluck'
        end
      end
      
      module InstanceMethods
        def say
          "I'm speaking"
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, BearBrand::Acts::Exclusive)