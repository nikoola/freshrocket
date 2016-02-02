
Array.class_eval do
	def pluck(key)
		map { |h| h[key] }
	end
end




