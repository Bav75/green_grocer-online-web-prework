require "pry"

def consolidate_cart(cart)
  consolidated_cart = {}

  cart.each do |element|
    element.each do |item, attributes|
        if consolidated_cart[item].nil? 
          consolidated_cart[item] = attributes.merge({:count => 1})
        else
          consolidated_cart[item][:count] += 1
        end
      end
    end
  #binding.pry
  return consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon.each do |attribute, value|
      item = coupon[:item]
      if cart[item] && cart[item][:count] >= coupon[:num] #if more items than coupons
        if cart["#{item} W/COUPON"] #if coupon item exists
          cart["#{item} W/COUPON"][:count] += 1
        else
          cart["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[item][:clearance], :count => 1} #create coupon item
        end
        cart[item][:count] -= coupon[:num] #apply coupon a decrease count
      end
    end
  end
  cart 
end

def apply_clearance(cart)
  cart.each do |item, attributes|
    if attributes[:clearance]
      attributes[:price] = (attributes[:price] *0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cost = 0
  temp_cart = consolidate_cart(cart)
  coupon_applied_cart = apply_coupons(temp_cart, coupons)
  final_cart = apply_clearance(coupon_applied_cart)

  final_cart.each do |item, attributes|
    cost += (attributes[:price] * attributes[:count]) #calculate total cost
  end

  cost = (cost * 0.9) if cost > 100
  cost
end
