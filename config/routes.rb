Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'

  mount ActionCable.server => '/cable'
end
