require 'active_record'

module BearBrand
  module Acts
    module Exclusive
      # included is called from the ActiveRecord::Base when you inject this module
      def self.included(base)
        # Add acts_as_exclusive availability by extending the module that owns the function.
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_exclusive(options)
          extend Exclusive::SingletonMethods
          
          @conditions_string=options[:conditions]
          @joins=options[:joins]
        end
      end
      
      module SingletonMethods
        #exclusive search - wrapper around AR::B#find
        #Expects an owner key in options hash
        def search(options)
          owner = options[:owner]
          conditions = [@conditions_string, owner.id] #array
          extra_conditions = options[:conditions] #array
          
          #hackish weird way to add another AR condition
          if extra_conditions and ! extra_conditions.empty?
            conditions[0]+=" AND #{extra_conditions[0]}"
            #fails if more then 1 ec is provided
            conditions.push(extra_conditions[1])
          end
          
          find(:all, :joins => @joins, :conditions => conditions)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, BearBrand::Acts::Exclusive)