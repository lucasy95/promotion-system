#module Api
#  module V1
#    class CouponsController   =    Api::V1::CouponsController
#    end
#  end
#end

class Api::V1::CouponsController < Api::V1::ApiController
  def show
    @coupon = Coupon.find_by(code: params[:code])
    render json: @coupon.as_json(include: [:promotion])    #ñ precisa do as_json, pq o rails ja transform para json sozinho
  end

  def index
    @coupons = Coupon.all
    render json: @coupons
  end
end
