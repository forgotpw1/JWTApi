Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :account, default: {format: :json} do
        post 'register'
        post 'login'
      end
    end
  end
end
