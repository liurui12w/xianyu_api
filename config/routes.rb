Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"

  namespace :api, defaults: { format: :json } do

    namespace :small_pro do
      resources :wares do
        collection do
          get :s_ranking_list_list
          post :get_ware_data
        end
      end



    end
  end
end
