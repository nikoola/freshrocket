class User < ActiveRecord::Base

	has_one :delivery_boy, autosave: true #used in manipulate_user_abilities

	devise  :database_authenticatable, :registerable,
					:rememberable, :trackable, :validatable,
					:omniauthable #TODO get rid of some
	# notice this comes BEFORE the include statement below
	include DeviseTokenAuth::Concerns::User

	has_many :orders    #no dependent: :destroy since we can't delete users
	has_many :addresses

	validates_presence_of   :phone, :first_name, :last_name
	validates_uniqueness_of :phone

	validates               :phone, 
		numericality: { only_integer: true },
		length:       { is: 12 }


	before_update :reset_verification, if: :phone_changed? #will run on create too because of autosave (http://stackoverflow.com/a/28034043/3192470)





	acts_as_taggable_on :abilities

	VALID_ABILITY_NAMES = %w(orders products users categories coupons settings cities delivery_boy) #why tags and not create separate roles table? because it's nice to keep app logic in app.
	validate :validate_abilities


	include Filterable
	scope :email_includes, -> (text)    { where("email like ?", "%#{text}%") }
	scope :phone_includes, -> (text)    { where("phone like ?", "%#{text}%") }
	scope :has_abillity,   -> (ability) { tagged_with(ability) }




	# TODO delete delivery_boy_extension on delivery_boy: 0.





	def has_abillity? tag_name
		self.abilities.any? { |ability| ability.name == tag_name.to_s }
	end



	# for callbacks
	def add_ability ability_name
		if !ability_list.include? ability_name

			if ability_name.to_sym == :delivery_boy
				if delivery_boy
					delivery_boy.status = :unavailable #from fired to unavailable.
				else
					build_delivery_boy
				end
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



	def name
		"#{first_name} #{last_name}"
	end





	private

		def validate_abilities
			invalid_abilities = self.ability_list - VALID_ABILITY_NAMES
			invalid_abilities.each do |ability|
				errors.add(:abilities, ability + ' is not a valid ability')
			end
		end

		def reset_verification
			self.is_verified = false
			true
		end







end
