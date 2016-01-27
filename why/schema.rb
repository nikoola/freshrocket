
___why products_in_cart?

	we could make Order   has_and_belongs_to_many :products
	              Product has_and_belongs_to_many :orders
	        with order_products table.
	but then we'd need to add 10 records to say that we ordered 10 fishes.
	so we'll create products_in_cart table:
					:order_id
					:product_id
					:amount
	and has_many :through association.
	besides, it's confortable frontend-wise.

	rails g migration create_products_in_carts order:references product:references amount:integer





