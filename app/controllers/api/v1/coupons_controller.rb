# module Api
#  module V1
#    class CouponsController   =    Api::V1::CouponsController
#    end
#  end
# end

class Api::V1::CouponsController < Api::V1::ApiController
  def show
    @coupon = Coupon.find_by!(code: params[:code])
    # render json: @coupon.as_json(include: [:promotion]) #mostra a promoção do cupom
    render json: @coupon.as_json(methods: %i[promotion_name discount_rate
                                             expiration_date],
                                 except: %i[id promotion_id
                                            created_at updated_at])
  end

  def index
    @coupons = Coupon.all
    render json: @coupons
  end

  def usado
    @coupon = Coupon.find_by!(code: params[:code])
    @coupon.usado!
    head 200
  end

  def create
    @coupon = Coupon.new(cp_params)
    if @coupon.save
      head 201
    else
      head 422
    end
  end

  def update
    @coupon = Coupon.find_by!(code: params[:code])
    if @coupon.update!(cp_params)
      head 200
    else
      head 422
    end
  end

  def destroy
    @coupon = Coupon.find_by!(code: params[:code])
    @coupon.destroy
  end

  private

  def cp_params
    params.require(:coupon).permit(:code, :promotion_id)
  end
end
