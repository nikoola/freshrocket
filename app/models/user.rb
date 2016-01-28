class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  # before_save -> { skip_confirmation! } #no devise :confirmable

	has_many :orders

  has_one :login


	# # validates_presence_of :phone 
	# validates_inclusion_of :role, in: ['client', 'admin']

	# def client?
	# 	self.role == 'client'
	# end

	# def admin?
	# 	self.role == 'admin'
	# end

end

