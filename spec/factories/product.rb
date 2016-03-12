FactoryGirl.define do
	factory :product do
		title           'fish'
		price           3.0
		inventory_count 20
		association     :city

		factory :product_with_image do
			after(:create) do |product, evaluator|

				pic_names = %w[hello hey hi wooow wow]

				image = "#{Rails.root}/spec/files/#{pic_names.sample}.jpg"
				file = Rack::Test::UploadedFile.new image, "image/jpeg"

				product.update! image: file

			end
		end

	end
end
