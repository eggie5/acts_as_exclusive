Given a user model and a resource model. A single user has multiple resources. We need an easy method to get all resources that belong to a given user. Enter acts_as_exclusive. A given resource is exclusive to a given user and shouldn't be accessible from a different user. Acts_as_exclusive is meant to be used by a higher level method (controller) to facilitate the need for exclusiveness of certain resources to a certain owners.

class User < AR::B
	has_many :properties
end

class Property < AR::B
	belongs_to :user
	acts_as_exclusive :conditions => "users.id=?"
end

	***

class PropertiesController < AC
	def index
		# finds all properties under owner - other's property is hidden
		Property.find(:all_exclusive_to, :owner => @user.id)
	end
...

end
