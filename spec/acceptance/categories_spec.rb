require 'rails_helper'

RSpec.describe 'Categories', type: :request do

	before(:each) do
		@category = FactoryGirl.create :category
	end

	describe 'GET /categories' do
		it 'with no params' do
			get categories_path

			names_from_json = json_body.map {|a| a[:name]}
			names_from_db   = Category.pluck(:name)

			expect(names_from_json).to eq(names_from_db)
		end

		it 'GET /categories?city_id=1&in_stock=false' do
			get '/categories?city_id=1&in_stock=false', {}
			#TODO beter test may be needed
			expect_status 200
		end

	end


end
