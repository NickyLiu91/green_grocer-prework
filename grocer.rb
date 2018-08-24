def consolidate_cart(cart)
  new_hash = {}
  count = 0
  cart.each do |hash|
    hash.each do |item, info|
      new_hash[item] ||= info

      new_hash[item][:count] ||= 0
      new_hash[item][:count] += 1
    end
  end
  new_hash

end

def apply_coupons(cart, coupons)
  coupon_item = []
  coupons.each do |hash|
    coupon_item << [hash[:item], hash[:cost], hash[:num]]
  end

  coupon_item.each do |item|
    unless cart.include?(item[0])
      coupon_item.delete(item)
    end
  end

  coupon_item.each do |item|
    cart["#{item[0]} W/COUPON"] ||= {}
      cart["#{item[0]} W/COUPON"][:clearance] = cart[item[0]][:clearance]
      cart["#{item[0]} W/COUPON"][:price] = item[1]
      cart[item[0]][:count] -= item[2]
      cart["#{item[0]} W/COUPON"][:count] ||= 0
      cart["#{item[0]} W/COUPON"][:count] += 1
  end

  cart
end

def apply_clearance(cart)
  cart.each do |item, info_hash|
    if info_hash[:clearance]
      info_hash[:price] = info_hash[:price]/5
    end
  end
  cart
end

def checkout(cart, coupons)
  apply_coupons(cart, coupons)
  apply_clearance(cart)
  total = 0
  cart.each do |item, info|
    total += info[:price]
  end
  if total > 100
    total * 0.9
  end
end
