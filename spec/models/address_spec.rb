require 'rails_helper'


describe Address, type: :model do

	# let(:address) { FactoryGirl.create :address }


	describe 'validations' do

		it 'has_no_approved_orders?' do
			order = FactoryGirl.create :order
			address = order.address

			order.confirm!
			order.approve!

			address.update(door_number: 5)

			expect(address).to be_invalid
			expect(address.errors.messages).to include :address => ["can't be changed after some approved order uses it"]
		end

		describe ':is_in_deliverable_area?' do
			it 'doesnt run if no :coordinate was given' do
				attrs = FactoryGirl.attributes_for(:address).except(:stringified_coordinate)
				address = Address.new attrs

				expect(-> { address.valid? }).to_not raise_error
			end

			it 'passes' do
				address = FactoryGirl.create :address
				expect(address).to be_valid
			end

			it 'fails' do
				city    = FactoryGirl.create :city, polygon: CITY_POLYGON[:doesnt_contain_coordinate]
				address = FactoryGirl.build :address, city: city
				expect(address).to be_invalid
			end


		end


	end





	






end