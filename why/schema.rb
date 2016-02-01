
___why line_item?

	we could make Order   has_and_belongs_to_many :products
	              Product has_and_belongs_to_many :orders
	        with order_products table.
	but then we'd need to add 10 records to say that we ordered 10 fishes.
	so we'll create line_item table:
					:order_id
					:product_id
					:amount
	and has_many :through association.
	besides, its comfortable frontend-wise.

	rails g migration create_line_items order:references product:references amount:integer

___why not habtm for category - product relationship?
	habtm relationship does not support :dependent option http://stackoverflow.com/a/2799764/3192470
	I want categories_products record to be destroyed on  product desctruction.





