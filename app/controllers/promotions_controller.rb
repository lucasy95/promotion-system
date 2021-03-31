class PromotionsController < ApplicationController
  before_action :authenticate_user!, only: %i[ index show new create generate_coupons search edit destroy update ]
  before_action :set_promotion, only: [:show, :generate_coupons, :edit, :update, :destroy]  #filters

	def index
		@promotions = Promotion.all
	end

	def show
	end

	def edit
	end

	def update
    if @promotion.update(promotion_params)
      redirect_to @promotion
    else
      render :edit
    end
  end

	def new
		@promotion = Promotion.new
	end

  def destroy   #before_action
    @promotion.destroy
    flash[:alert] = "Promoção deletada"
    redirect_to promotions_path
  end

	def create
		@promotion = Promotion.new(promotion_params)
		if
			@promotion.save
			flash[:notice] = 'Promoção criada com sucesso'
		  redirect_to @promotion
	  else
			render :new
		end
	end

	def generate_coupons   #before_action
		@promotion.generate_coupons!
		redirect_to @promotion, notice: t('.success')
	end

  def search
    @promotions = Promotion.search(params[:buscar])
    render :index
  end


	private

	  def set_promotion
			@promotion = Promotion.find(params[:id])
		end


		def promotion_params
			params
				.require(:promotion)
				.permit(:name, :expiration_date, :description, :discount_rate, :code, :coupon_quantity)
		end
end
