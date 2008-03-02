require 'active_record'

module BearBrand
  module Acts
    module Exclusive
      # included is called from the ActiveRecord::Base when you inject this module
      def self.included(base)
        # Add acts_as_exclusive availability by extending the module that owns the function.
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
        #exclusive search - wrapper around AR::B#find
        #Expects an owner key in options hash
        def search(local_options = {})
          conditions = [options[:conditions], local_options[:owner].id] #array
          dynamic_conditions = local_options[:conditions] #array
          
          #hackish weird way to add another AR condition
          if dynamic_conditions and ! dynamic_conditions.empty?
            conditions[0]+=" AND #{dynamic_conditions[0]}"
            #fails if more then 1 ec is provided
            conditions.push(dynamic_conditions[1])
          end
          
          find(:all, :joins => options[:joins], :conditions => conditions)
        end
        
        # #override AR::B.find
        # def find(*args)
        #   sleep 3
        #   super
        # end
      end
    end
  end
end

ActiveRecord::Base.send(:include, BearBrand::Acts::Exclusive)