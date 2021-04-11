#module Api
#  module V1
#    class CouponsController   =    Api::V1::CouponsController
#    end
#  end
#end

class Api::V1::CouponsController < Api::V1::ApiController

  def show
    @coupon = Coupon.find_by!(code: params[:code])
    #render json: @coupon.as_json(include: [:promotion]) #mostra a promoção do cupom
    render json: @coupon.as_json(methods: [:promotion_name, :discount_rate,
                                           :expiration_date],
                                            except: [:id, :promotion_id,
                                                     :created_at, :updated_at])
    #render json: { expiration_date: @coupon.promotion.expiration_date }
  end

  def index
    @coupons = Coupon.all
    render json: @coupons
  end

end
