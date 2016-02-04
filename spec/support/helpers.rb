
Array.class_eval do
	def pluck(key)
		map { |h| h[key] }
	end
end




module Helpers

	def json #hash
		parsed = JSON.parse(response_body)
		parsed.deep_symbolize_keys!
	end

	def jsons #array of hashes
		parsed = JSON.parse(response_body)
		parsed.each { |a| a.deep_symbolize_keys! }
	end
	





end




