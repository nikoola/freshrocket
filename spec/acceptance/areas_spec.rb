require 'rails_helper'

resource "areas", type: :request do
	let(:user) { FactoryGirl.create :user, abilities: ['cities'] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:city)    { FactoryGirl.create :city }
	let(:area) { FactoryGirl.create :area, city_id: city.id }
	



end