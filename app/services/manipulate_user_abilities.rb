class ManipulateUserAbilities
	def initialize user, abilities_hash={}
		@user = user
		@abilities_hash = abilities_hash
	end


	def list
		hash = {}
		User::VALID_ABILITY_NAMES.each do |ability_name|
			hash[ability_name] = @user.has_abillity?(ability_name) ? 1 : 0
		end
		hash
	end

	def update
		@abilities_hash.each do |ability_name, value|

			case value
			when '0'
				@user.remove_ability ability_name
			when '1'
				@user.add_ability ability_name
			else
				render json: 'value should be 1 or 0', status: :unprocessable_entity
			end

		end

	end







end







