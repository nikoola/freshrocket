class User < ActiveRecord::Base


	has_one :delivery_boy, autosave: true #used in manipulate_user_abilities

	devise :database_authenticatable, :registerable,
					:recoverable, :rememberable, :trackable, :validatable,
					:omniauthable
	include DeviseTokenAuth::Concerns::User

	belongs_to :city #for delivery boys to be found based on their location. and for users to be given default city on log in.

	has_many :orders, dependent: :destroy #TODO should we be able to delete users?
	validates_presence_of :phone



	acts_as_taggable_on :abilities

	VALID_ABILITY_NAMES = %w(orders products users categories settings delivery_boy) #why tags and not create separate roles table? because it's nice to keep app logic in app.
	validate :validate_abilities


	include Filterable
	scope :email_includes, -> (text)    { where("email like ?", "%#{text}%") }
	scope :phone_includes, -> (text)    { where("phone like ?", "%#{text}%") }
	scope :has_abillity,   -> (ability) { tagged_with(ability) }
	# scope :city_id         -> (id)      { where(city_id: id) }




	# TODO delete delivery_boy_extension on delivery_boy: 0.





	def has_abillity? tag_name
		self.abilities.any? { |ability| ability.name == tag_name.to_s }
	end



	# for callbacks
	def add_ability ability_name
		if !ability_list.include? ability_name

			if ability_name.to_sym == :delivery_boy
				build_delivery_boy
			end #alternative to callbacks. because well, there are no callbacks for aato.

			ability_list.add(ability_name)
		end
	end

	def remove_ability ability_name
		if ability_list.include? ability_name

			if ability_name.to_sym == :delivery_boy
				delivery_boy.status = :fired
			end

			ability_list.remove(ability_name)
		end
	end







	private

		def validate_abilities
			invalid_abilities = self.ability_list - VALID_ABILITY_NAMES
			invalid_abilities.each do |ability|
				errors.add(:abilities, ability + ' is not a valid ability')
			end
		end






end
