class User < ActiveRecord::Base

	devise :database_authenticatable, :registerable,
					:recoverable, :rememberable, :trackable, :validatable,
					:omniauthable
	include DeviseTokenAuth::Concerns::User

	has_many :orders, dependent: :destroy #TODO should we be able to delete users?
	validates_presence_of :phone

	has_many :deliveries, foreign_key: 'delivery_boy_id'#, inverse_of: :delivery_boy #for users with delivery_boy ability


	acts_as_taggable_on :abilities

	VALID_ABILITY_NAMES = %w(orders products users categories settings delivery_boy) #why tags and not create separate roles table? because it's nice to keep app logic in app.
	validate :validate_abilities


	include Filterable
	scope :email_includes, -> (text)    { where("email like ?", "%#{text}%") }
	scope :phone_includes, -> (text)    { where("phone like ?", "%#{text}%") }
	scope :has_abillity,   -> (ability) { tagged_with(ability) }










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
