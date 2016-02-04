require 'rails_helper'

resource 'Products', type: :request do

	let(:user) { FactoryGirl.create :user, abilities: ['categories'] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:category) { FactoryGirl.create :category }

	post '/admin/categories' do
		parameter :name, 'name of a category', require: true, scope: :category

		example 'create category' do
			do_request({ category: {name: 'breakfasts'} })

			expect(status).to eq(201)
			expect(json).to include :id, :name
		end

		example 'create category: invalid params' do
			do_request({ category: {name: nil} })

			expect(status).to eq(422)
			expect(json).to include :name => ["can't be blank"]
		end
	end

	put '/admin/categories/:id' do
		parameter :name, 'name of a category', require: true, scope: :category

		example 'update category' do
			do_request({ id: category.id, category: {name: 'hollywood'} })

			expect(status).to eq(200)
			expect(json).to include :id, :name
		end


		it 'update category: with invalid params' do
			do_request({ id: category.id, category: {name: nil} })

			expect(status).to eq(422)
			expect(json).to include :name=>["can't be blank"]
		end
	end

	delete '/admin/categories/:id' do
		it 'delete category' do
			do_request({ id: category.id })

			expect(status).to eq(200)
		end

	end








end
