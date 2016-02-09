class DeliverySerializer < ActiveModel::Serializer
  attributes :id,
  	:order_id, :delivery_boy_id,
  	:wanted_time, :wanted_date
end
