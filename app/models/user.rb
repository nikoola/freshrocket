class User < ActiveRecord::Base

	devise :database_authenticatable, :registerable,
					:recoverable, :rememberable, :trackable, :validatable,
					:omniauthable
	include DeviseTokenAuth::Concerns::User

	has_many :orders
	validates_presence_of :phone


	acts_as_taggable_on :abilities

	VALID_ABILITY_NAMES = %w(orders products users categories) #why tags and not create separate roles table? because it's nice to keep app logic in app.
	validate :validate_abilities



	def has_abillity? tag_name
		self.abilities.any? { |ability| ability.name == tag_name.to_s }
	end





	private

		def validate_abilities
			invalid_abilities = self.ability_list - VALID_ABILITY_NAMES
			invalid_abilities.each do |ability|
				errors.add(:abilities, ability + ' is not a valid ability')
			end
		end







end

# inventory_count --