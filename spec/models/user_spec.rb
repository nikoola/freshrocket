require 'rails_helper'


describe User, type: :model do

	before(:each) do
		@user = FactoryGirl.create :user
	end

	describe 'abilities' do
		it 'saves if properly set' do
			@user.ability_list = ['orders', 'products']
			@user.save; @user.reload
			expect(@user.abilities.map(&:name)).to contain_exactly('orders', 'products')
		end

		it 'errory if no such ability allowed' do
			@user.ability_list = ['orders', 'wrongy']
			@user.save
			expect(@user).not_to be_valid
			expect(@user.errors.messages).to include({:abilities => ["wrongy is not a valid ability"]})
		end

		it '.has_ability? :products' do
			@user.ability_list = ['orders']
			@user.save; @user.reload;

			expect(@user.has_ability? :orders).to be(true)
			expect(@user.has_ability? :products).to be(false)
		end

		it 'doesnt add tag twice' do
			@user.ability_list = ['orders', 'products']
			@user.ability_list.add('orders')
			@user.save; @user.reload
			expect(@user.abilities.map(&:name)).to contain_exactly('orders', 'products')
		end
	end
end



