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
        #Preforms AR::B:find, returning all records exclusive to owner
        def search(local_options = {})
          #this is the main sql filter that limits results to a given owner
          #example: ["content_providers.id = ?" 4]
          conditions = [options[:conditions], local_options[:owner].id] #array
          
          #append run-time sql conditions
          dynamic_conditions = local_options[:conditions] #array
          if dynamic_conditions and ! dynamic_conditions.empty?
            conditions[0]+=" AND #{dynamic_conditions[0]}"
            #fails if more then 1 ec is provided
            conditions.push(dynamic_conditions[1])
          end
          
          #run find exclusive to owner
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