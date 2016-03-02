class ContactForm
	include ActiveModel::Model
	include Virtus.model

	# Attributes (DSL provided by Virtus)
	attribute :name,     String
	attribute :email,    String
	attribute :order_id, Integer
	attribute :message,  String


	# Validations
	validates_presence_of :name, :email, :message
	validates :order_id,  numericality: { only_integer: true, greater_than: 0 }, allow_blank: true



end