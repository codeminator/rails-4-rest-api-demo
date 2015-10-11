class User < ActiveRecord::Base
	extend Enumerize
	acts_as_token_authenticatable
	
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #-----Attributes
  enumerize :role, in: [:admin, :user], default: :user

  #-----Methods
  def is?(role_name)
  	self.role == role_name.to_s
  end
end
