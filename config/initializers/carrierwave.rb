require 'carrierwave/orm/activerecord'


CarrierWave.configure do |config|

	config.fog_credentials = {
		provider:              'AWS',
		aws_access_key_id:     'AKIAI2A2EM3U4PUMSEOA',#ENV['aws.access_key_id'] || 'AKIAJHCUQYEJAT3MCZ3A',
		aws_secret_access_key: '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',#ENV['aws.secret_access_key'] || 'iiHSVhZvP9kEkHnx/vOGtsPbpLxTVUxIzGncGCCG',
		region:                'ap-southeast-1' #if region is wrong it'll raise SignatureDoesNotMatch
	}

	config.fog_directory =   'freshrocket'#ENV['aws.fog_directory']

end


