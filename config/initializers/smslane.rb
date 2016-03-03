
require 'smslane'



SMSLANE = Rails.application.config_for(:smslane).with_indifferent_access


module Smslane
	Client.class_eval do
		
		def send_sms recipients, message, options = {}
			defaults = { fl: 0, gwid: 2, sid: 'FRESHR', msg: message }
			options.merge! defaults

		  responses = []
		  recipients = recipients.each_slice(90).to_a
		  recipients.each do |recipient_list|
		    recipient_list.each_with_index do |number,i|
		      recipient_list[i] = '91'+number[-10..-1]
		      if /^(\+91|91)[789][0-9]{9}$/.match(recipient_list[i]).nil?
		        recipient_list.delete_at(i)
		      end
		    end
		    options = {
		    	:query => @auth.merge({:msisdn=>recipient_list.join(',')}).merge(options)
		  	}
		    responses << send(options).parsed_response
		  end
		  
		  responses.delete('Failed#Invalid Mobile Numbers')
		  responses = responses.join().split('<br />')
		  result = []
		  responses.each do |response|
		  	begin
		    	res = response[-45..-1].split('-')
		    rescue
		    	return responses
		    end
		    result << {:number => res[0], :message_id=>res[1]}
		  end
		  result
		end

	end
end