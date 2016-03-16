require 'rails_helper'

resource 'admin: categories', type: :request do

	let(:user) { FactoryGirl.create :user, abilities: ['categories'] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:category) { FactoryGirl.create :category }

	post '/admin/categories' do
		with_options scope: :category do
			parameter :name,  'name of a category', required: true
			parameter :image, 'base64 encoded image'
		end

		example 'create category' do
			image_path = "#{Rails.root}/spec/files/hi.jpg"
			image = File.open(image_path, "rb").read
			image_data = "data:image/jpg;base64," + Base64.encode64(image)

			do_request({ 
				category: {
					name:  'breakfasts',
					image: image_data
				}
			})

			expect(status).to eq(201)
			expect(json).to include :id, :name, :image_url
			expect(json[:image_url]).to eq("https://#{ENV['aws.fog_directory']}.s3.amazonaws.com/uploads/category/image/#{json[:id]}/file.jpg")
		end

		example 'create category: invalid params', document: false do
			do_request({ category: {name: nil} })

			expect(status).to eq(422)
			expect(json).to include :name => ["can't be blank"]
		end
	end

	put '/admin/categories/:id' do
		with_options scope: :category do
			parameter :name, 'name of a category'
			parameter :image, 'base64 encoded image'
			parameter :remove_image
		end

		example 'update category' do
			image_path = "#{Rails.root}/spec/files/hi.jpg"
			image = File.open(image_path, "rb").read
			image_data = "data:image/jpg;base64," + Base64.encode64(image)
			
			category = Category.create name: 'hell', image: image_data

			do_request({ id: category.id, 
				category: {
					remove_image: '1',
					name: 'hollywood'
				} 
			})

			expect(status).to eq(200)
			expect(json[:name]).to  eq('hollywood')
			expect(json[:image]).to be_nil
		end




		it 'update category: with invalid params', document: false do
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
