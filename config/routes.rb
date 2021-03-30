Rails.application.routes.draw do
  devise_for :users
	root 'home#index'

	resources :promotions, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
		post 'generate_coupons', on: :member
	end

	resources :coupons, only: [] do
		post 'disable', on: :member    #especificar cupom/ ñ pode ser get
	end

  resources :categories, only: [:new,:show, :index, :create, :edit, :update, :destroy]

end
