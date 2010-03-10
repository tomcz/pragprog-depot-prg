module OrdersHelper

  def order_date_format(order)
    order.created_at.localtime.strftime('%d/%m/%Y %H:%M:%S')
  end

end
