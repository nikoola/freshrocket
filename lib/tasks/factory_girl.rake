namespace :factory_girl do
	desc "Verify that all FactoryGirl factories are valid"
	task lint: :environment do
		if Rails.env.test?
			begin
				DatabaseCleaner.start

				a = FactoryGirl.factories.instance_variable_get(:@items)
				b = a.except :line_item

				FactoryGirl.lint b
			ensure
				DatabaseCleaner.clean
			end
		else
			system("bundle exec rake factory_girl:lint RAILS_ENV='test'")
		end
	end
end

