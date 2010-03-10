xml.order_list(:for_product => @product.title) do
  for order in @orders
    xml.order do
      xml.name(order.name)
      xml.email(order.email)
    end
  end
end