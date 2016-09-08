require 'rails_helper'


describe Address, type: :model do

	# let(:address) { FactoryGirl.create :address }
	let(:city) {FactoryGirl.create :city}
	let(:area) {FactoryGirl.create :area, city_id: city.id}
	let(:user) {FactoryGirl.create :user}

	describe 'validations' do

		it 'is a create example' do
			# area = FactoryGirl.create :area
			address = FactoryGirl.create :address,:area_id => area.id, :user_id => user.id, :city_id => area.city.id
		end

		it 'is a create test without explicit area' do
			# area = FactoryGirl.create :area
			address = FactoryGirl.create :address, :associations#, :area => area
		end
		# it 'has_no_approved_orders?', :focus => true do
		# 	order = FactoryGirl.create :order
		# 	address = order.address

		# 	order.confirm!
		# 	order.approve!

		# 	address.update(door_number: 5)

		# 	expect(address).to be_invalid
		# 	expect(address.errors.messages).to include :address => ["can't be changed after some approved order uses it"]
		# end

		# describe ':is_in_deliverable_area?' do
		# 	it 'doesnt run if no :coordinate was given' do
		# 		attrs = FactoryGirl.attributes_for(:address).except(:stringified_coordinate)
		# 		address = Address.new attrs

		# 		expect(-> { address.valid? }).to_not raise_error
		# 	end

		# 	it 'passes' do
		# 		address = FactoryGirl.create :address
		# 		expect(address).to be_valid
		# 	end

		# 	it 'fails' do
		# 		city    = FactoryGirl.create :city, polygon: CITY_POLYGON[:doesnt_contain_coordinate]
		# 		address = FactoryGirl.build :address, city: city
		# 		expect(address).to be_invalid
		# 	end


		#end


	end
end