require 'carrierwave/orm/activerecord'


CarrierWave.configure do |config|

	config.fog_credentials = {
		provider:              'AWS',
		aws_access_key_id:     ENV['aws.access_key_id'] || 'AKIAJHCUQYEJAT3MCZ3A',
		aws_secret_access_key: ENV['aws.secret_access_key'] || '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',
		region:                'ap-southeast-1' #if region is wrong it'll raise SignatureDoesNotMatch
	}

	config.fog_directory =   ENV['aws.fog_directory']

end


