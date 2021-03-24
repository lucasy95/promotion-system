class PromotionsController < ApplicationController
	def index
		@promotions = Promotion.all
	end

	def show
		@promotion = Promotion.find(params[:id])
	end

	def edit
		@promotion = Promotion.find(params[:id])
	end

	def update
    @promotion = Promotion.find(params[:id])
    if @promotion.update(promotion_params)
      redirect_to @promotion
    else
      render :edit
    end
  end

	def new
		@promotion = Promotion.new
	end

  def destroy
    @promotion = Promotion.find(params[:id])
    @promotion.destroy
    redirect_to promotions_path
  end

	def create
		@promotion = Promotion.new(promotion_params)
		if
			@promotion.save
		  redirect_to @promotion
	  else
			render :new
		end
	end

	def generate_coupons
		@promotion = Promotion.find(params[:id])

    (1..@promotion.coupon_quantity).each do |number|
       Coupon.create!(code: "#{@promotion.code}-#{'%04d' % number}", promotion: @promotion)
    end

		flash[:notice] = 'Cupons gerados com sucesso'
		redirect_to @promotion
	end

	private

		def promotion_params
			params
				.require(:promotion)
				.permit(:name, :expiration_date, :description, :discount_rate, :code, :coupon_quantity)
		end
end
