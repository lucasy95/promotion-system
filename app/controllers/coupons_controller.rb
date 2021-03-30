class CouponsController < ApplicationController
  def disable
    @coupon = Coupon.find(params[:id])
    @coupon.disabled!
    redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)  #volta para a promoção referente ao cupom, método vem do belongs_to
  end

  def enable
    @coupon = Coupon.find(params[:id])
    @coupon.active!
    redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
  end
end
