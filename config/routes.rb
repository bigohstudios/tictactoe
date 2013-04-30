Tictactoe::Application.routes.draw do
  resources :games do
    resources :turns, :only => :create
  end

  root 'games#index'
end
