class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

	has_many :orders



	validates_presence_of :phone, :role
	validates_inclusion_of :role, in: ['client', 'admin'] #enum sucks

	before_validation :default_values
	def default_values
	  self.role ||= 'client'
	end


	def client?
		self.role == 'client'
	end
	def admin?
		self.role == 'admin'
	end

end

# inventory_count --