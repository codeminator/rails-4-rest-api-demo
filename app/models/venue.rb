class Venue < ActiveRecord::Base

	#-----Associations
	has_many :activities, dependent: :destroy
	belongs_to :creator, class_name: 'User', foreign_key: :created_by

	#-----Validations
	validates :name, presence: true, uniqueness: true
	validates :creator, presence: true
	

	validates :latitude , numericality: { 
		greater_than_or_equal_to: -90, less_than_or_equal_to:  90 
	}
	validates :longitude, numericality: { 
		greater_than_or_equal_to: -180, less_than_or_equal_to: 180
	}
end
