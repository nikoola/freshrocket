
Array.class_eval do
	def pluck(key)
		map { |h| h[key] }
	end
end




module Helpers

	def json #hash
		parsed = JSON.parse(response_body)
		parsed.symbolize_keys!
	end

	def jsons #array of hashes
		parsed = JSON.parse(response_body)
		parsed.each { |a| a.symbolize_keys! }
	end
	
end




