class PromotionsController < ApplicationController
  before_action :authenticate_user!, only: %i[ index show new create generate_coupons search edit destroy update ]
  before_action :set_promotion, only: [:show, :generate_coupons, :edit, :update, :destroy, :approve]  #filters
  before_action :can_be_approved, only: %i[ approve ]

	def index
		@promotions = Promotion.all
	end

	def show
	end

	def edit
    @user = current_user
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
		@promotion = current_user.promotions.new(promotion_params)  #método do has_many
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

  def approve
    #PromotionApproval.create!(promotion: @promotion, user: current_user )
    current_user.promotion_approvals.create!(promotion: @promotion)
    redirect_to @promotion, notice: 'Promoção aprovada com sucesso'
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

    def can_be_approved
      redirect_to @promotion, alert: 'Ação não permitida' unless @promotion.can_approve?(current_user)
    end
end
