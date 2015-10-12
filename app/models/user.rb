class User < ActiveRecord::Base
  extend Enumerize 
  acts_as_token_authenticatable
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #-----Attributes
  #Check config/configatron/defaults.rb to know about available_roles
  enumerize :role, in: configatron.models.user.available_roles, default: :guest

  #-----Assiciations
  has_many :venues, foreign_key: :created_by, dependent: :destroy
  has_many :activities

  #-----Methods
  def is?(role_name)
    self.role == role_name.to_s
  end
end
