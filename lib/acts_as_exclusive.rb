require 'active_record'

module BearBrand
  module Acts
    module Exclusive
      def self.included(base)
        base.extend(ActsMethods)  
      end
      
      module ActsMethods
        def acts_as_exclusive(options = {})
          class_inheritable_accessor :options
          extend Exclusive::ClassMethods
          
          self.options = options
        end
      end
      
      module ClassMethods
        def find(*args)
          if(args.first.to_s == "all_exclusive_to")
            raise ArgumentError.new("You must provide a :owner argument") if args[1].blank?
            owner_id = args[1][:owner]
            super(:all, :joins => options[:joins], :conditions => [options[:conditions], owner_id])
          else
            super
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, BearBrand::Acts::Exclusive)