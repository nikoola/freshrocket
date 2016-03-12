require 'carrierwave/orm/activerecord'


CarrierWave.configure do |config|

	config.fog_credentials = {
		provider:              'AWS',                      
		aws_access_key_id:     ENV['aws.access_key_id'],   
		aws_secret_access_key: ENV['aws.secret_access_key'],
		region:                'ap-southeast-1'
	}

	config.fog_directory  = 'freshrocket'                

end


