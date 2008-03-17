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
        #Property.find(:all, :exclusive_to => @user.id)
        def find(*args)
          if(args[0].to_s == "all" and args[1].to_s.include?("exclusive_to"))
            local_options = args.extract_options!
            
            conditions = [options[:conditions], local_options[:exclusive_to]]
            
            #merge local_options conditions hash with same in options
            dynamic_conditions = local_options[:conditions] #array
            if dynamic_conditions and ! dynamic_conditions.empty?
              conditions[0]+=" AND #{dynamic_conditions[0]}"
              #fails if more then 1 ec is provided
              conditions.push(dynamic_conditions[1])
            end
            
            super(:all, :joins => options[:joins], :conditions => conditions)
          else
            super
          end
        end
        
        #alias for find(:all, :exclusive_to => @user.id)
        #Property.find_all_exclusive_to(:owner => @user.id)
        def find_all_exclusive_to(args={})
          #translat this to: find(:all, :exclusive_to => id)
          find(:all, :exclusive_to => args[:owner_id], :conditions => args[:conditions])
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, BearBrand::Acts::Exclusive)