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

  #When 'updating' enumerized attribute (with default value) with nil, 
  #it will be saved normally without applying the presence validation (probably a bug)
  validates :name, presence: true, on: :update
  validates :measure_unit, presence: true, on: :update
  validates :user, presence: true
  validates :venue, presence: true

  validates :distance, numericality: { greater_than: 0 }

end
