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


	end





	






end