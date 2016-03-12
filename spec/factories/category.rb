FactoryGirl.define do
	factory :category do
		sequence(:name) { |i| "Category #{i}" }

		factory :category_with_image do
			after(:create) do |category, evaluator|

				pic_names = %w[hello hey hi wooow wow]

				image = "#{Rails.root}/spec/files/#{pic_names.sample}.jpg"
				file = Rack::Test::UploadedFile.new image, "image/jpeg"

				category.update! image: file

			end
		end




	end
end
