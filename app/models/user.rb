class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  belongs_to :company
  has_and_belongs_to_many :roles
  has_many :events

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end
  
  def name
    last_name.nil? ? first_name : first_name + " " + last_name
  end
  
end
