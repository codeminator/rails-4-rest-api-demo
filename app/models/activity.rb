class Activity < ActiveRecord::Base
  extend Enumerize

  #-----Attributes
  enumerize :name, in: configatron.models.activity.available_names, default: :running
  enumerize :measure_unit, in: configatron.models.activity.available_measure_units, default: :km

  #-----Asociations
  belongs_to :user
  belongs_to :venue

  #-----validations
  ###Thanks to Enumerize, we already have inclusion validation for name, measure_unit
  validates :user, presence: true
  validates :venue, presence: true

  validates :distance, numericality: { greater_than: 0 }

end
